#!/bin/bash
#
# Instalador de las interfaces ROS 2 de Kalman Robotics.
#
#   curl -fsSL https://kalmanrobotics.io/install-kalman-interfaces.sh | sudo bash
#
# Detecta la version de Ubuntu y elige el ROS distro correspondiente.
# Se puede forzar con la variable de entorno ROS_DISTRO:
#
#   curl -fsSL ... | sudo ROS_DISTRO=jazzy bash
#
set -euo pipefail

BUCKET_URL="https://kalmanrobotics.s3.amazonaws.com/packages"
KEYRING="/usr/share/keyrings/kalman-robotics.gpg"
SOURCES_LIST="/etc/apt/sources.list.d/kalman-robotics.list"

echo "Installing Kalman Robotics ROS packages..."

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: este script necesita privilegios de root. Usa sudo." >&2
    exit 1
fi

# --- Detectar la version de Ubuntu ---------------------------------------
if ! command -v lsb_release >/dev/null 2>&1; then
    apt-get update
    apt-get install -y lsb-release
fi

UBUNTU_CODENAME="$(lsb_release -cs)"
ARCH="$(dpkg --print-architecture)"

# --- Mapear codename -> ROS distro ---------------------------------------
# ROS_DISTRO puede venir del entorno para forzar una eleccion concreta
# (p.ej. dos distros comparten la misma base de Ubuntu).
if [ -z "${ROS_DISTRO:-}" ]; then
    case "${UBUNTU_CODENAME}" in
        jammy)  ROS_DISTRO="humble" ;;
        noble)  ROS_DISTRO="jazzy"  ;;
        *)
            echo "Error: Ubuntu '${UBUNTU_CODENAME}' no esta soportado." >&2
            echo "Soportados: jammy (22.04 -> humble), noble (24.04 -> jazzy)." >&2
            echo "Puedes forzar uno con: ROS_DISTRO=<distro> $0" >&2
            exit 1
            ;;
    esac
fi

PACKAGE="ros-${ROS_DISTRO}-kalman-interfaces"

echo "  Ubuntu:  ${UBUNTU_CODENAME} (${ARCH})"
echo "  ROS:     ${ROS_DISTRO}"
echo "  Paquete: ${PACKAGE}"

# --- Dependencias del propio instalador ----------------------------------
apt-get update
apt-get install -y curl gnupg

# --- Clave GPG del repositorio -------------------------------------------
# --yes para que una reinstalacion sobreescriba el keyring existente
curl -fsSL "${BUCKET_URL}/kalman.gpg" | gpg --dearmor --yes -o "${KEYRING}"
chmod 0644 "${KEYRING}"

# --- Repositorio apt -----------------------------------------------------
echo "deb [arch=${ARCH} signed-by=${KEYRING}] ${BUCKET_URL} ${UBUNTU_CODENAME} main" \
    > "${SOURCES_LIST}"

# --- Instalar ------------------------------------------------------------
apt-get update
apt-get install -y "${PACKAGE}"

echo ""
echo "Done! Run: source /opt/ros/${ROS_DISTRO}/setup.bash"

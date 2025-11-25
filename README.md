# kalman_interfaces
Paquete de mensajes personalizados de ROS2 para la plataforma de software Kaia.ai. Este paquete define las interfaces de comunicación utilizadas por los robots basados en Kaia.ai.

- [kalman\_interfaces](#kalman_interfaces)
  - [Mensajes Definidos](#mensajes-definidos)
    - [Sensores](#sensores)
      - [`ImuData.msg`](#imudatamsg)
    - [Actuadores](#actuadores)
      - [`Led.msg`](#ledmsg)
    - [Conectividad y Eventos](#conectividad-y-eventos)
      - [`WifiState.msg`](#wifistatemsg)
      - [`OnlineEvent.msg`](#onlineeventmsg)
    - [Odometría y Telemetría](#odometría-y-telemetría)
      - [`KaiaaiTelemetry.msg`](#kaiaaitelemetrymsg)
      - [`KaiaaiTelemetry2.msg`](#kaiaaitelemetry2msg)
      - [`JointPosVel.msg`](#jointposvelmsg)
    - [Control de Motores](#control-de-motores)
      - [`Motors.msg`](#motorsmsg)
      - [`ControlStatus.msg`](#controlstatusmsg)
      - [`ConfigParams.msg`](#configparamsmsg)
  - [Compilación](#compilación)
  - [Uso](#uso)


## Mensajes Definidos

### Sensores

#### [`ImuData.msg`](msg/ImuData.msg)
Datos de la unidad de medición inercial (IMU):
- `accel_x`, `accel_y`, `accel_z`: Aceleración en ejes X, Y, Z
- `gyro_x`, `gyro_y`, `gyro_z`: Velocidad angular en ejes X, Y, Z

### Actuadores

#### [`Led.msg`](msg/Led.msg)
Control de LED RGB:
- `state`: Estado ON/OFF
- `r`, `g`, `b`: Canales de color (0-255)
- `intensity`: Intensidad/brillo (0-255)

### Conectividad y Eventos

#### [`WifiState.msg`](msg/WifiState.msg)
Estado de la conexión WiFi:
- `stamp`: Marca de tiempo
- `rssi_dbm`: Intensidad de señal en dBm

#### [`OnlineEvent.msg`](msg/OnlineEvent.msg)
Eventos de conexión/desconexión del robot:
- `event`: Tipo de evento (`EVENT_ONLINE=0`, `EVENT_OFFLINE=1`)
- `comment`: Descripción del evento
- `diag`: Datos de diagnóstico adicionales

### Odometría y Telemetría

#### [`KaiaaiTelemetry.msg`](msg/KaiaaiTelemetry.msg)
Mensaje de telemetría básica del robot que incluye:
- `stamp`: Marca de tiempo
- `seq`: Número de secuencia
- `odom_pos_x`, `odom_pos_y`, `odom_pos_yaw`: Posición odométrica
- `odom_vel_x`, `odom_vel_yaw`: Velocidades odométricas
- `joint_pos[]`, `joint_vel[]`: Posiciones y velocidades de articulaciones
- `lds[]`: Datos del sensor láser

#### [`KaiaaiTelemetry2.msg`](msg/KaiaaiTelemetry2.msg)
Versión extendida de telemetría con datos adicionales:
- Incluye todos los campos de `KaiaaiTelemetry`
- `joint`: Array de hasta 15 posiciones/velocidades ([`JointPosVel`](msg/JointPosVel.msg))
- `wifi_rssi_dbm`: Intensidad de señal WiFi
- `battery_mv`: Voltaje de batería en mV
- `distance_mm[]`: Array de sensores de distancia
- `bumper[]`, `cliff[]`, `touch[]`: Sensores de colisión, precipicio y táctiles
- `scan_start_hint`: Indicador de inicio de escaneo

#### [`JointPosVel.msg`](msg/JointPosVel.msg)
Posición y velocidad de una articulación individual:
- `pos`: Posición
- `vel`: Velocidad

### Control de Motores

#### [`Motors.msg`](msg/Motors.msg)
Control de motores izquierdo y derecho:
- `motor_l`: Motor izquierdo
- `motor_r`: Motor derecho

#### [`ControlStatus.msg`](msg/ControlStatus.msg)
Estado detallado del controlador PID para ambos motores:
- `r_*`: Parámetros del motor derecho (control, velocidad, error, setpoint)
- `l_*`: Parámetros del motor izquierdo (control, velocidad, error, setpoint)

#### [`ConfigParams.msg`](msg/ConfigParams.msg)
Parámetros de configuración del controlador:
- `kp`: Ganancia proporcional
- `ki`: Ganancia integral
- `kd`: Ganancia derivativa
- `alpha`: Parámetro de filtrado

## Compilación

```bash
cd ~/ros2_ws
colcon build --packages-select kalman_interfaces
source install/setup.bash
```

## Uso

Para usar estos mensajes en un nodo de ROS2:

**C++:**
```cpp
#include "kalman_interfaces/msg/motors.hpp"
#include "kalman_interfaces/msg/kaiaai_telemetry2.hpp"
```

**Python:**
```python
from kalman_interfaces.msg import Motors, KaiaaiTelemetry2
```

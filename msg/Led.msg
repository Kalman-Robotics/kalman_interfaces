# Led.msg
# LED interface: on/off plus RGB color (0-255)
# state: true = ON, false = OFF
bool state

# RGB color channels (0-255)
uint8 r
uint8 g
uint8 b

# Intensity/brightness (0-255)
uint8 intensity
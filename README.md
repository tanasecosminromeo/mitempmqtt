# mitempmqtt
Get temperature and humidity from Xiaomi Mijia flashed with https://github.com/pvvx/ATC_MiThermometer and send them to a private MQTT server (via ssh tunnel)

What it uses
--
- MiTemperature2 / ATC Thermometer version 5.0 https://github.com/JsBergbau/MiTemperature2#readme in **mitemperature** container that colects data from `mitemperature/sensors.ini` and sends it to a MQTT server
- ssh *(will be changed to autossh)* using supervisor in portforward to create a portforward for the MQTT broker
- bluetooth

What you need to set in .env
--
- The **GATEWAY** to the MQTT broker. **eg: "root@192.168.68.64 -p 2220"** if you want to create a ssh tunnel to that ip address. MAKE SURE YOUR HOST ~/.ssh/id_rsa is allowed to connect to that host OR you can use **GATEWAY=off** if the MQTT broker is running locally
- **PORTFORWARD** is the actual link that needs to be created. If you don't want to edit `mitemperature/mqtt.conf` you need to forward this to port `1883`. **eg: "PORTFORWARD=1883:localhost:1883"**

Tested on
--
- Debian GNU/Linux 11 (bullseye) 64 bits
- Raspberry PI4 - Raspian OS Lite 32 bits

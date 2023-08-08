# mitempmqtt v1.0.0
Get temperature and humidity from Xiaomi Mijia flashed with https://github.com/pvvx/ATC_MiThermometer and send them to a private MQTT server (via ssh tunnel OR not)

I built this project as I can't get in range of all my bluetooth sensors from anywhere, but I do have a bunch of Raspberry PIs that I also use for other stuff. Multiple instances of this project on multiple devices MAY connect to the same sensors, but this means that you should always get an up to date state for that sensor so, all good.

Another good advantage of using this tool is that once you flash your devices and add them to sensors.ini you set it and forget it, especially since the MQTT Discovery option in HA.

## What it uses
- MiTemperature2 / ATC Thermometer version 5.0 https://github.com/JsBergbau/MiTemperature2#readme in **mitemperature** container that colects data from `mitemperature/sensors.ini` and sends it to a MQTT server
- ssh *(will be changed to autossh)* using supervisor in portforward to create a portforward for the MQTT broker
- bluetooth

## Tested on
- Debian GNU/Linux 11 (bullseye) 64 bits
- Raspberry PI4 - Raspian OS Lite 32 bits

## Configure and Run
### .env
Copy `.env.dist` to `.env` and configure as follows
- The **GATEWAY** to the MQTT broker. **eg: "root@192.168.68.64 -p 2220"** if you want to create a ssh tunnel to that ip address. MAKE SURE YOUR HOST ~/.ssh/id_rsa is allowed to connect to that host OR you can use **GATEWAY=off** if the MQTT broker is running locally
- **PORTFORWARD** is the actual link that needs to be created. If you don't want to edit `mitemperature/mqtt.conf` you need to forward this to port `1883`. **eg: "PORTFORWARD=1883:localhost:1883"**
### sensors.ini
In `./mitemperature` you have `sensors.ini.dist`, copy this to `./mitemperature/sensors.ini` and configure accordingly. PS: I also use this repo to remember mine, so make sure this correctly reflects your setup!
### How to run?
Easy `docker-compose up -d` and if you preconfigured all of the above you're gold!

### Easier version?
If you just want this to run along side a Home Assistant container, checkout `docker-compose.yml.sample.ha.yml` - setup just your sensors.ini and you're good to go!

You don't want to use docker compose?

```
docker run -d \
  --name mitemperature \
  --restart always \
  --network host \
  --privileged \
  -v $(pwd)/mitemperature/sensors.ini:/sensors.ini \
  tanasecosminromeo/mitemperature:latest
```

## How to use in Home Assistant
- Install an MQTT broker *(or add to this container, I may add a version here too using mosquitto broker https://hub.docker.com/_/eclipse-mosquitto )* 
- Add MQTT Integration

### Home Assistant - Option 1 - MQTT Discovery
Now Home Assistant accepts MQTT Discovery and I have amended app.py (LYWSD03MMC.py from https://github.com/JsBergbau/MiTemperature2) to automatically configure your sensors *IF callback=homeassistant is present for the sensor definiton*

If you do not want your sensor to be automatically discovered in home assistant, remember to remove that line or write no _(or anything else for that matter)_

As easy as that!

### Home Assistant - Option 2 - Manual usage
- Setup sensors

Example of sensors.yaml
--
```
- platform: mqtt
  name: "Bedroom Temperature"
  state_topic: "mitemp/bedroom"
  unit_of_measurement: "°C"
  value_template: "{{ value_json.temperature }}"
- platform: mqtt
  name: "Bedroom Humidity"
  icon: "mdi:water-percent"
  state_topic: "mitemp/bedroom"
  unit_of_measurement: "%"
  value_template: "{{ value_json.humidity }}"
```


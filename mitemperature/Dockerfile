FROM python:3.7.12-slim

ENV LANG C.UTF-8

RUN apt-get update -y && apt-get -y --no-install-recommends install python3-pip libglib2.0-dev libbluetooth-dev build-essential
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN /usr/local/bin/pip3.7 install bluepy requests paho-mqtt pybluez pycryptodomex

COPY app.py app.py 
COPY sensors.ini sensors.ini
COPY mqtt.conf mqtt.conf
COPY cryptoFunctions.py cryptoFunctions.py
COPY bluetooth_utils.py bluetooth_utils.py

ENTRYPOINT while true; do /usr/local/bin/python3.7 app.py --atc --mqttconfigfile mqtt.conf --devicelistfile sensors.ini --skipidentical 50 -deb; sleep 2; done

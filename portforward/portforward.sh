#!/bin/sh

if [[ -z "$GATEWAY" || -z "$PORTFORWARD" ]]; then
  echo "GATEWAY or PORTFORWARD not set in .env"
  exit;
fi;

if [[ "$GATEWAY" == "off" ]]; then
  echo "GATEWAY is set to off"
  exit;
fi;

echo "Connecting to $GATEWAY and setting local port forward $PORTFORWARD"
connectionTry=0;
while true; 
  do 
    connectionTry=$connectionTry+1
    echo Connecting $conectionTry
    ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa -nNT -o GatewayPorts=true $GATEWAY -4 -L $PORTFORWARD; 
    echo Connection closed
done

#!/usr/bin/env bash

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Optional step - it takes couple of seconds (or longer) to establish a WiFi connection
# sometimes. In this case, following checks will fail and wifi-connect
# will be launched even if the device will be able to connect to a WiFi network.
# If this is your case, you can wait for a while and then check for the connection.
# sleep 15

# Choose a condition for running WiFi Connect according to your use case:

# 1. Is there a default gateway?
# ip route | grep default

# 2. Is there Internet connectivity?
# nmcli -t g | grep full

# 3. Is there Internet connectivity via a google ping?
# wget --spider http://google.com 2>&1

# 4. Is there an active WiFi connection?
# iwgetid -r
echo "192.168.42.1 samizdapp.localhost" >> /etc/hosts
echo "192.168.42.1 samizdapp.local" >> /etc/hosts
ETH=$(ip a show eth0 up | grep inet)
iwgetid -r



if [ $? -eq 0 ]; then
    echo 'Have WiFi Connect\n'
    if [ -z "$ETH" ]; then
      echo "no ethernet, do nothing"
    else
      echo "have wifi + ethernet, enable hotspot"
      printf 'Starting WiFi Connect\n'
      ./wifi-connect --portal-listening-port 8000
    fi
else
  echo "no wifi, start hotspot"
  printf 'Starting WiFi Connect\n'
  ./wifi-connect --portal-listening-port 8000
fi

# Start your application here.
sleep infinity

#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [auto|dns1,dns2|403|shecan]"
    exit 1
fi

connection_name=$(nmcli -t -f NAME,TYPE con show --active | grep wireless | cut -d':' -f1)

if [ -z "$connection_name" ]; then
    echo "No active WiFi connection found."
    exit 1
fi

case "$1" in
    "auto")
        echo "Setting DNS to automatic for $connection_name"
        nmcli connection modify "$connection_name" ipv4.dns "" ipv4.ignore-auto-dns no
        ;;
    "403")
        echo "Setting DNS to 1.2.3.4, 5.5.5.5 for $connection_name"
        nmcli connection modify "$connection_name" ipv4.dns "10.202.10.202,10.202.10.102" ipv4.ignore-auto-dns yes
        ;;
    "shecan")
        echo "Setting DNS to 185.51.200.2 for $connection_name"
        nmcli connection modify "$connection_name" ipv4.dns "178.22.122.100,185.51.200.2" ipv4.ignore-auto-dns yes
        ;;
    *)
        IFS=',' read -ra dns_servers <<< "$1"
        echo "Setting DNS to ${dns_servers[@]} for $connection_name"
        nmcli connection modify "$connection_name" ipv4.dns "${dns_servers[@]}" ipv4.ignore-auto-dns yes
        ;;
esac

echo "Restarting network manager..."
sudo systemctl restart NetworkManager

echo "Restarting $connection_name..."
nmcli connection down "$connection_name"
nmcli connection up "$connection_name"

echo "DNS configuration updated successfully."

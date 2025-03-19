#!/bin/bash

# This script sets up the virtual network interfaces for the onvif-server
# and starts the server with the config.yaml file

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

# Set system settings to prevent MAC address conflicts
echo "Setting system settings to prevent MAC address conflicts..."
sysctl -w net.ipv4.conf.all.arp_ignore=1
sysctl -w net.ipv4.conf.all.arp_announce=2

# Set the main network interface
INTERFACE="enp10s0"
echo "Using network interface: $INTERFACE"

# Create virtual network interfaces for each camera
echo "Creating virtual network interfaces..."

# Camera 1
ip link add onvif-proxy-1 link $INTERFACE address a2:a2:a2:a2:a2:a1 type macvlan mode bridge
ip link set onvif-proxy-1 up
dhclient onvif-proxy-1
echo "Created onvif-proxy-1 with MAC a2:a2:a2:a2:a2:a1 and requested IP via DHCP"

# Camera 2
ip link add onvif-proxy-2 link $INTERFACE address a2:a2:a2:a2:a2:a2 type macvlan mode bridge
ip link set onvif-proxy-2 up
dhclient onvif-proxy-2
echo "Created onvif-proxy-2 with MAC a2:a2:a2:a2:a2:a2 and requested IP via DHCP"

# Camera 3
ip link add onvif-proxy-3 link $INTERFACE address a2:a2:a2:a2:a2:a3 type macvlan mode bridge
ip link set onvif-proxy-3 up
dhclient onvif-proxy-3
echo "Created onvif-proxy-3 with MAC a2:a2:a2:a2:a2:a3 and requested IP via DHCP"

# Camera 4
ip link add onvif-proxy-4 link $INTERFACE address a2:a2:a2:a2:a2:a4 type macvlan mode bridge
ip link set onvif-proxy-4 up
dhclient onvif-proxy-4
echo "Created onvif-proxy-4 with MAC a2:a2:a2:a2:a2:a4 and requested IP via DHCP"

# Camera 5
ip link add onvif-proxy-5 link $INTERFACE address a2:a2:a2:a2:a2:a5 type macvlan mode bridge
ip link set onvif-proxy-5 up
dhclient onvif-proxy-5
echo "Created onvif-proxy-5 with MAC a2:a2:a2:a2:a2:a5 and requested IP via DHCP"

# Camera 6
ip link add onvif-proxy-6 link $INTERFACE address a2:a2:a2:a2:a2:a6 type macvlan mode bridge
ip link set onvif-proxy-6 up
dhclient onvif-proxy-6
echo "Created onvif-proxy-6 with MAC a2:a2:a2:a2:a2:a6 and requested IP via DHCP"

# Camera 7
ip link add onvif-proxy-7 link $INTERFACE address a2:a2:a2:a2:a2:a7 type macvlan mode bridge
ip link set onvif-proxy-7 up
dhclient onvif-proxy-7
echo "Created onvif-proxy-7 with MAC a2:a2:a2:a2:a2:a7 and requested IP via DHCP"

# Camera 8
ip link add onvif-proxy-8 link $INTERFACE address a2:a2:a2:a2:a2:a8 type macvlan mode bridge
ip link set onvif-proxy-8 up
dhclient onvif-proxy-8
echo "Created onvif-proxy-8 with MAC a2:a2:a2:a2:a2:a8 and requested IP via DHCP"

# Camera 9
ip link add onvif-proxy-9 link $INTERFACE address a2:a2:a2:a2:a2:a9 type macvlan mode bridge
ip link set onvif-proxy-9 up
dhclient onvif-proxy-9
echo "Created onvif-proxy-9 with MAC a2:a2:a2:a2:a2:a9 and requested IP via DHCP"

# Camera 10
ip link add onvif-proxy-10 link $INTERFACE address a2:a2:a2:a2:a2:b1 type macvlan mode bridge
ip link set onvif-proxy-10 up
dhclient onvif-proxy-10
echo "Created onvif-proxy-10 with MAC a2:a2:a2:a2:a2:b1 and requested IP via DHCP"

# Camera 11
ip link add onvif-proxy-11 link $INTERFACE address a2:a2:a2:a2:a2:b2 type macvlan mode bridge
ip link set onvif-proxy-11 up
dhclient onvif-proxy-11
echo "Created onvif-proxy-11 with MAC a2:a2:a2:a2:a2:b2 and requested IP via DHCP"

# Camera 12
ip link add onvif-proxy-12 link $INTERFACE address a2:a2:a2:a2:a2:b3 type macvlan mode bridge
ip link set onvif-proxy-12 up
dhclient onvif-proxy-12
echo "Created onvif-proxy-12 with MAC a2:a2:a2:a2:a2:b3 and requested IP via DHCP"

# Camera 13
ip link add onvif-proxy-13 link $INTERFACE address a2:a2:a2:a2:a2:b4 type macvlan mode bridge
ip link set onvif-proxy-13 up
dhclient onvif-proxy-13
echo "Created onvif-proxy-13 with MAC a2:a2:a2:a2:a2:b4 and requested IP via DHCP"

# Camera 14
ip link add onvif-proxy-14 link $INTERFACE address a2:a2:a2:a2:a2:b5 type macvlan mode bridge
ip link set onvif-proxy-14 up
dhclient onvif-proxy-14
echo "Created onvif-proxy-14 with MAC a2:a2:a2:a2:a2:b5 and requested IP via DHCP"

# Camera 15
ip link add onvif-proxy-15 link $INTERFACE address a2:a2:a2:a2:a2:b6 type macvlan mode bridge
ip link set onvif-proxy-15 up
dhclient onvif-proxy-15
echo "Created onvif-proxy-15 with MAC a2:a2:a2:a2:a2:b6 and requested IP via DHCP"

# Camera 16
ip link add onvif-proxy-16 link $INTERFACE address a2:a2:a2:a2:a2:b7 type macvlan mode bridge
ip link set onvif-proxy-16 up
dhclient onvif-proxy-16
echo "Created onvif-proxy-16 with MAC a2:a2:a2:a2:a2:b7 and requested IP via DHCP"

echo "All virtual network interfaces created successfully!"
echo ""
echo "The virtual interfaces will now request IP addresses via DHCP."
echo "You can set static IP reservations for these MAC addresses in your Unifi router."
echo ""
echo "You can now start the onvif-server with:"
echo "node main.js ./config.yaml"
echo ""
echo "Note: These virtual network settings will be lost when you reboot the system."
echo "You'll need to run this script again after each reboot."

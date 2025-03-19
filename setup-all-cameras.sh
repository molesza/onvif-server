#!/bin/bash

# This script sets up all the virtual network interfaces for all the onvif-servers

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

# NVR 1: 192.168.0.207 (16 cameras)
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

# NVR 2: 192.168.0.49 (16 cameras)
# Camera 17
ip link add onvif-proxy-17 link $INTERFACE address a2:a2:a2:a2:a3:a1 type macvlan mode bridge
ip link set onvif-proxy-17 up
dhclient onvif-proxy-17
echo "Created onvif-proxy-17 with MAC a2:a2:a2:a2:a3:a1 and requested IP via DHCP"

# Camera 18
ip link add onvif-proxy-18 link $INTERFACE address a2:a2:a2:a2:a3:a2 type macvlan mode bridge
ip link set onvif-proxy-18 up
dhclient onvif-proxy-18
echo "Created onvif-proxy-18 with MAC a2:a2:a2:a2:a3:a2 and requested IP via DHCP"

# Camera 19
ip link add onvif-proxy-19 link $INTERFACE address a2:a2:a2:a2:a3:a3 type macvlan mode bridge
ip link set onvif-proxy-19 up
dhclient onvif-proxy-19
echo "Created onvif-proxy-19 with MAC a2:a2:a2:a2:a3:a3 and requested IP via DHCP"

# Camera 20
ip link add onvif-proxy-20 link $INTERFACE address a2:a2:a2:a2:a3:a4 type macvlan mode bridge
ip link set onvif-proxy-20 up
dhclient onvif-proxy-20
echo "Created onvif-proxy-20 with MAC a2:a2:a2:a2:a3:a4 and requested IP via DHCP"

# Camera 21
ip link add onvif-proxy-21 link $INTERFACE address a2:a2:a2:a2:a3:a5 type macvlan mode bridge
ip link set onvif-proxy-21 up
dhclient onvif-proxy-21
echo "Created onvif-proxy-21 with MAC a2:a2:a2:a2:a3:a5 and requested IP via DHCP"

# Camera 22
ip link add onvif-proxy-22 link $INTERFACE address a2:a2:a2:a2:a3:a6 type macvlan mode bridge
ip link set onvif-proxy-22 up
dhclient onvif-proxy-22
echo "Created onvif-proxy-22 with MAC a2:a2:a2:a2:a3:a6 and requested IP via DHCP"

# Camera 23
ip link add onvif-proxy-23 link $INTERFACE address a2:a2:a2:a2:a3:a7 type macvlan mode bridge
ip link set onvif-proxy-23 up
dhclient onvif-proxy-23
echo "Created onvif-proxy-23 with MAC a2:a2:a2:a2:a3:a7 and requested IP via DHCP"

# Camera 24
ip link add onvif-proxy-24 link $INTERFACE address a2:a2:a2:a2:a3:a8 type macvlan mode bridge
ip link set onvif-proxy-24 up
dhclient onvif-proxy-24
echo "Created onvif-proxy-24 with MAC a2:a2:a2:a2:a3:a8 and requested IP via DHCP"

# Camera 25
ip link add onvif-proxy-25 link $INTERFACE address a2:a2:a2:a2:a3:a9 type macvlan mode bridge
ip link set onvif-proxy-25 up
dhclient onvif-proxy-25
echo "Created onvif-proxy-25 with MAC a2:a2:a2:a2:a3:a9 and requested IP via DHCP"

# Camera 26
ip link add onvif-proxy-26 link $INTERFACE address a2:a2:a2:a2:a3:b1 type macvlan mode bridge
ip link set onvif-proxy-26 up
dhclient onvif-proxy-26
echo "Created onvif-proxy-26 with MAC a2:a2:a2:a2:a3:b1 and requested IP via DHCP"

# Camera 27
ip link add onvif-proxy-27 link $INTERFACE address a2:a2:a2:a2:a3:b2 type macvlan mode bridge
ip link set onvif-proxy-27 up
dhclient onvif-proxy-27
echo "Created onvif-proxy-27 with MAC a2:a2:a2:a2:a3:b2 and requested IP via DHCP"

# Camera 28
ip link add onvif-proxy-28 link $INTERFACE address a2:a2:a2:a2:a3:b3 type macvlan mode bridge
ip link set onvif-proxy-28 up
dhclient onvif-proxy-28
echo "Created onvif-proxy-28 with MAC a2:a2:a2:a2:a3:b3 and requested IP via DHCP"

# Camera 29
ip link add onvif-proxy-29 link $INTERFACE address a2:a2:a2:a2:a3:b4 type macvlan mode bridge
ip link set onvif-proxy-29 up
dhclient onvif-proxy-29
echo "Created onvif-proxy-29 with MAC a2:a2:a2:a2:a3:b4 and requested IP via DHCP"

# Camera 30
ip link add onvif-proxy-30 link $INTERFACE address a2:a2:a2:a2:a3:b5 type macvlan mode bridge
ip link set onvif-proxy-30 up
dhclient onvif-proxy-30
echo "Created onvif-proxy-30 with MAC a2:a2:a2:a2:a3:b5 and requested IP via DHCP"

# Camera 31
ip link add onvif-proxy-31 link $INTERFACE address a2:a2:a2:a2:a3:b6 type macvlan mode bridge
ip link set onvif-proxy-31 up
dhclient onvif-proxy-31
echo "Created onvif-proxy-31 with MAC a2:a2:a2:a2:a3:b6 and requested IP via DHCP"

# Camera 32
ip link add onvif-proxy-32 link $INTERFACE address a2:a2:a2:a2:a3:b7 type macvlan mode bridge
ip link set onvif-proxy-32 up
dhclient onvif-proxy-32
echo "Created onvif-proxy-32 with MAC a2:a2:a2:a2:a3:b7 and requested IP via DHCP"

# NVR 3: 192.168.0.63 (16 cameras)
# Camera 33
ip link add onvif-proxy-33 link $INTERFACE address a2:a2:a2:a2:a4:a1 type macvlan mode bridge
ip link set onvif-proxy-33 up
dhclient onvif-proxy-33
echo "Created onvif-proxy-33 with MAC a2:a2:a2:a2:a4:a1 and requested IP via DHCP"

# Camera 34
ip link add onvif-proxy-34 link $INTERFACE address a2:a2:a2:a2:a4:a2 type macvlan mode bridge
ip link set onvif-proxy-34 up
dhclient onvif-proxy-34
echo "Created onvif-proxy-34 with MAC a2:a2:a2:a2:a4:a2 and requested IP via DHCP"

# Camera 35
ip link add onvif-proxy-35 link $INTERFACE address a2:a2:a2:a2:a4:a3 type macvlan mode bridge
ip link set onvif-proxy-35 up
dhclient onvif-proxy-35
echo "Created onvif-proxy-35 with MAC a2:a2:a2:a2:a4:a3 and requested IP via DHCP"

# Camera 36
ip link add onvif-proxy-36 link $INTERFACE address a2:a2:a2:a2:a4:a4 type macvlan mode bridge
ip link set onvif-proxy-36 up
dhclient onvif-proxy-36
echo "Created onvif-proxy-36 with MAC a2:a2:a2:a2:a4:a4 and requested IP via DHCP"

# Camera 37
ip link add onvif-proxy-37 link $INTERFACE address a2:a2:a2:a2:a4:a5 type macvlan mode bridge
ip link set onvif-proxy-37 up
dhclient onvif-proxy-37
echo "Created onvif-proxy-37 with MAC a2:a2:a2:a2:a4:a5 and requested IP via DHCP"

# Camera 38
ip link add onvif-proxy-38 link $INTERFACE address a2:a2:a2:a2:a4:a6 type macvlan mode bridge
ip link set onvif-proxy-38 up
dhclient onvif-proxy-38
echo "Created onvif-proxy-38 with MAC a2:a2:a2:a2:a4:a6 and requested IP via DHCP"

# Camera 39
ip link add onvif-proxy-39 link $INTERFACE address a2:a2:a2:a2:a4:a7 type macvlan mode bridge
ip link set onvif-proxy-39 up
dhclient onvif-proxy-39
echo "Created onvif-proxy-39 with MAC a2:a2:a2:a2:a4:a7 and requested IP via DHCP"

# Camera 40
ip link add onvif-proxy-40 link $INTERFACE address a2:a2:a2:a2:a4:a8 type macvlan mode bridge
ip link set onvif-proxy-40 up
dhclient onvif-proxy-40
echo "Created onvif-proxy-40 with MAC a2:a2:a2:a2:a4:a8 and requested IP via DHCP"

# Camera 41
ip link add onvif-proxy-41 link $INTERFACE address a2:a2:a2:a2:a4:a9 type macvlan mode bridge
ip link set onvif-proxy-41 up
dhclient onvif-proxy-41
echo "Created onvif-proxy-41 with MAC a2:a2:a2:a2:a4:a9 and requested IP via DHCP"

# Camera 42
ip link add onvif-proxy-42 link $INTERFACE address a2:a2:a2:a2:a4:b1 type macvlan mode bridge
ip link set onvif-proxy-42 up
dhclient onvif-proxy-42
echo "Created onvif-proxy-42 with MAC a2:a2:a2:a2:a4:b1 and requested IP via DHCP"

# Camera 43
ip link add onvif-proxy-43 link $INTERFACE address a2:a2:a2:a2:a4:b2 type macvlan mode bridge
ip link set onvif-proxy-43 up
dhclient onvif-proxy-43
echo "Created onvif-proxy-43 with MAC a2:a2:a2:a2:a4:b2 and requested IP via DHCP"

# Camera 44
ip link add onvif-proxy-44 link $INTERFACE address a2:a2:a2:a2:a4:b3 type macvlan mode bridge
ip link set onvif-proxy-44 up
dhclient onvif-proxy-44
echo "Created onvif-proxy-44 with MAC a2:a2:a2:a2:a4:b3 and requested IP via DHCP"

# Camera 45
ip link add onvif-proxy-45 link $INTERFACE address a2:a2:a2:a2:a4:b4 type macvlan mode bridge
ip link set onvif-proxy-45 up
dhclient onvif-proxy-45
echo "Created onvif-proxy-45 with MAC a2:a2:a2:a2:a4:b4 and requested IP via DHCP"

# Camera 46
ip link add onvif-proxy-46 link $INTERFACE address a2:a2:a2:a2:a4:b5 type macvlan mode bridge
ip link set onvif-proxy-46 up
dhclient onvif-proxy-46
echo "Created onvif-proxy-46 with MAC a2:a2:a2:a2:a4:b5 and requested IP via DHCP"

# Camera 47
ip link add onvif-proxy-47 link $INTERFACE address a2:a2:a2:a2:a4:b6 type macvlan mode bridge
ip link set onvif-proxy-47 up
dhclient onvif-proxy-47
echo "Created onvif-proxy-47 with MAC a2:a2:a2:a2:a4:b6 and requested IP via DHCP"

# Camera 48
ip link add onvif-proxy-48 link $INTERFACE address a2:a2:a2:a2:a4:b7 type macvlan mode bridge
ip link set onvif-proxy-48 up
dhclient onvif-proxy-48
echo "Created onvif-proxy-48 with MAC a2:a2:a2:a2:a4:b7 and requested IP via DHCP"

# NVR 4: 192.168.0.79 (16 cameras)
# Camera 49
ip link add onvif-proxy-49 link $INTERFACE address a2:a2:a2:a2:a5:a1 type macvlan mode bridge
ip link set onvif-proxy-49 up
dhclient onvif-proxy-49
echo "Created onvif-proxy-49 with MAC a2:a2:a2:a2:a5:a1 and requested IP via DHCP"

# Camera 50
ip link add onvif-proxy-50 link $INTERFACE address a2:a2:a2:a2:a5:a2 type macvlan mode bridge
ip link set onvif-proxy-50 up
dhclient onvif-proxy-50
echo "Created onvif-proxy-50 with MAC a2:a2:a2:a2:a5:a2 and requested IP via DHCP"

# Camera 51
ip link add onvif-proxy-51 link $INTERFACE address a2:a2:a2:a2:a5:a3 type macvlan mode bridge
ip link set onvif-proxy-51 up
dhclient onvif-proxy-51
echo "Created onvif-proxy-51 with MAC a2:a2:a2:a2:a5:a3 and requested IP via DHCP"

# Camera 52
ip link add onvif-proxy-52 link $INTERFACE address a2:a2:a2:a2:a5:a4 type macvlan mode bridge
ip link set onvif-proxy-52 up
dhclient onvif-proxy-52
echo "Created onvif-proxy-52 with MAC a2:a2:a2:a2:a5:a4 and requested IP via DHCP"

# Camera 53
ip link add onvif-proxy-53 link $INTERFACE address a2:a2:a2:a2:a5:a5 type macvlan mode bridge
ip link set onvif-proxy-53 up
dhclient onvif-proxy-53
echo "Created onvif-proxy-53 with MAC a2:a2:a2:a2:a5:a5 and requested IP via DHCP"

# Camera 54
ip link add onvif-proxy-54 link $INTERFACE address a2:a2:a2:a2:a5:a6 type macvlan mode bridge
ip link set onvif-proxy-54 up
dhclient onvif-proxy-54
echo "Created onvif-proxy-54 with MAC a2:a2:a2:a2:a5:a6 and requested IP via DHCP"

# Camera 55
ip link add onvif-proxy-55 link $INTERFACE address a2:a2:a2:a2:a5:a7 type macvlan mode bridge
ip link set onvif-proxy-55 up
dhclient onvif-proxy-55
echo "Created onvif-proxy-55 with MAC a2:a2:a2:a2:a5:a7 and requested IP via DHCP"

# Camera 56
ip link add onvif-proxy-56 link $INTERFACE address a2:a2:a2:a2:a5:a8 type macvlan mode bridge
ip link set onvif-proxy-56 up
dhclient onvif-proxy-56
echo "Created onvif-proxy-56 with MAC a2:a2:a2:a2:a5:a8 and requested IP via DHCP"

# Camera 57
ip link add onvif-proxy-57 link $INTERFACE address a2:a2:a2:a2:a5:a9 type macvlan mode bridge
ip link set onvif-proxy-57 up
dhclient onvif-proxy-57
echo "Created onvif-proxy-57 with MAC a2:a2:a2:a2:a5:a9 and requested IP via DHCP"

# Camera 58
ip link add onvif-proxy-58 link $INTERFACE address a2:a2:a2:a2:a5:b1 type macvlan mode bridge
ip link set onvif-proxy-58 up
dhclient onvif-proxy-58
echo "Created onvif-proxy-58 with MAC a2:a2:a2:a2:a5:b1 and requested IP via DHCP"

# Camera 59
ip link add onvif-proxy-59 link $INTERFACE address a2:a2:a2:a2:a5:b2 type macvlan mode bridge
ip link set onvif-proxy-59 up
dhclient onvif-proxy-59
echo "Created onvif-proxy-59 with MAC a2:a2:a2:a2:a5:b2 and requested IP via DHCP"

# Camera 60
ip link add onvif-proxy-60 link $INTERFACE address a2:a2:a2:a2:a5:b3 type macvlan mode bridge
ip link set onvif-proxy-60 up
dhclient onvif-proxy-60
echo "Created onvif-proxy-60 with MAC a2:a2:a2:a2:a5:b3 and requested IP via DHCP"

# Camera 61
ip link add onvif-proxy-61 link $INTERFACE address a2:a2:a2:a2:a5:b4 type macvlan mode bridge
ip link set onvif-proxy-61 up
dhclient onvif-proxy-61
echo "Created onvif-proxy-61 with MAC a2:a2:a2:a2:a5:b4 and requested IP via DHCP"

# Camera 62
ip link add onvif-proxy-62 link $INTERFACE address a2:a2:a2:a2:a5:b5 type macvlan mode bridge
ip link set onvif-proxy-62 up
dhclient onvif-proxy-62
echo "Created onvif-proxy-62 with MAC a2:a2:a2:a2:a5:b5 and requested IP via DHCP"

# Camera 63
ip link add onvif-proxy-63 link $INTERFACE address a2:a2:a2:a2:a5:b6 type macvlan mode bridge
ip link set onvif-proxy-63 up
dhclient onvif-proxy-63
echo "Created onvif-proxy-63 with MAC a2:a2:a2:a2:a5:b6 and requested IP via DHCP"

# Camera 64
ip link add onvif-proxy-64 link $INTERFACE address a2:a2:a2:a2:a5:b7 type macvlan mode bridge
ip link set onvif-proxy-64 up
dhclient onvif-proxy-64
echo "Created onvif-proxy-64 with MAC a2:a2:a2:a2:a5:b7 and requested IP via DHCP"

# NVR 5: 192.168.0.96 (32 cameras)
# Camera 65
ip link add onvif-proxy-65 link $INTERFACE address a2:a2:a2:a2:a6:a1 type macvlan mode bridge
ip link set onvif-proxy-65 up
dhclient onvif-proxy-65
echo "Created onvif-proxy-65 with MAC a2:a2:a2:a2:a6:a1 and requested IP via DHCP"

# Camera 66
ip link add onvif-proxy-66 link $INTERFACE address a2:a2:a2:a2:a6:a2 type macvlan mode bridge
ip link set onvif-proxy-66 up
dhclient onvif-proxy-66
echo "Created onvif-proxy-66 with MAC a2:a2:a2:a2:a6:a2 and requested IP via DHCP"

# Camera 67
ip link add onvif-proxy-67 link $INTERFACE address a2:a2:a2:a2:a6:a3 type macvlan mode bridge
ip link set onvif-proxy-67 up
dhclient onvif-proxy-67
echo "Created onvif-proxy-67 with MAC a2:a2:a2:a2:a6:a3 and requested IP via DHCP"

# Camera 68
ip link add onvif-proxy-68 link $INTERFACE address a2:a2:a2:a2:a6:a4 type macvlan mode bridge
ip link set onvif-proxy-68 up
dhclient onvif-proxy-68
echo "Created onvif-proxy-68 with MAC a2:a2:a2:a2:a6:a4 and requested IP via DHCP"

# Camera 69
ip link add onvif-proxy-69 link $INTERFACE address a2:a2:a2:a2:a6:a5 type macvlan mode bridge
ip link set onvif-proxy-69 up
dhclient onvif-proxy-69
echo "Created onvif-proxy-69 with MAC a2:a2:a2:a2:a6:a5 and requested IP via DHCP"

# Camera 70
ip link add onvif-proxy-70 link $INTERFACE address a2:a2:a2:a2:a6:a6 type macvlan mode bridge
ip link set onvif-proxy-70 up
dhclient onvif-proxy-70
echo "Created onvif-proxy-70 with MAC a2:a2:a2:a2:a6:a6 and requested IP via DHCP"

# Camera 71
ip link add onvif-proxy-71 link $INTERFACE address a2:a2:a2:a2:a6:a7 type macvlan mode bridge
ip link set onvif-proxy-71 up
dhclient onvif-proxy-71
echo "Created onvif-proxy-71 with MAC a2:a2:a2:a2:a6:a7 and requested IP via DHCP"

# Camera 72
ip link add onvif-proxy-72 link $INTERFACE address a2:a2:a2:a2:a6:a8 type macvlan mode bridge
ip link set onvif-proxy-72 up
dhclient onvif-proxy-72
echo "Created onvif-proxy-72 with MAC a2:a2:a2:a2:a6:a8 and requested IP via DHCP"

# Camera 73
ip link add onvif-proxy-73 link $INTERFACE address a2:a2:a2:a2:a6:a9 type macvlan mode bridge
ip link set onvif-proxy-73 up
dhclient onvif-proxy-73
echo "Created onvif-proxy-73 with MAC a2:a2:a2:a2:a6:a9 and requested IP via DHCP"

# Camera 74
ip link add onvif-proxy-74 link $INTERFACE address a2:a2:a2:a2:a6:b1 type macvlan mode bridge
ip link set onvif-proxy-74 up
dhclient onvif-proxy-74
echo "Created onvif-proxy-74 with MAC a2:a2:a2:a2:a6:b1 and requested IP via DHCP"

# Camera 75
ip link add onvif-proxy-75 link $INTERFACE address a2:a2:a2:a2:a6:b2 type macvlan mode bridge
ip link set onvif-proxy-75 up
dhclient onvif-proxy-75
echo "Created onvif-proxy-75 with MAC a2:a2:a2:a2:a6:b2 and requested IP via DHCP"

# Camera 76
ip link add onvif-proxy-76 link $INTERFACE address a2:a2:a2:a2:a6:b3 type macvlan mode bridge
ip link set onvif-proxy-76 up
dhclient onvif-proxy-76
echo "Created onvif-proxy-76 with MAC a2:a2:a2:a2:a6:b3 and requested IP via DHCP"

# Camera 77
ip link add onvif-proxy-77 link $INTERFACE address a2:a2:a2:a2:a6:b4 type macvlan mode bridge
ip link set onvif-proxy-77 up
dhclient onvif-proxy-77
echo "Created onvif-proxy-77 with MAC a2:a2:a2:a2:a6:b4 and requested IP via DHCP"

# Camera 78
ip link add onvif-proxy-78 link $INTERFACE address a2:a2:a2:a2:a6:b5 type macvlan mode bridge
ip link set onvif-proxy-78 up
dhclient onvif-proxy-78
echo "Created onvif-proxy-78 with MAC a2:a2:a2:a2:a6:b5 and requested IP via DHCP"

# Camera 79
ip link add onvif-proxy-79 link $INTERFACE address a2:a2:a2:a2:a6:b6 type macvlan mode bridge
ip link set onvif-proxy-79 up
dhclient onvif-proxy-79
echo "Created onvif-proxy-79 with MAC a2:a2:a2:a2:a6:b6 and requested IP via DHCP"

# Camera 80
ip link add onvif-proxy-80 link $INTERFACE address a2:a2:a2:a2:a6:b7 type macvlan mode bridge
ip link set onvif-proxy-80 up
dhclient onvif-proxy-80
echo "Created onvif-proxy-80 with MAC a2:a2:a2:a2:a6:b7 and requested IP via DHCP"

# Camera 81
ip link add onvif-proxy-81 link $INTERFACE address a2:a2:a2:a2:a7:a1 type macvlan mode bridge
ip link set onvif-proxy-81 up
dhclient onvif-proxy-81
echo "Created onvif-proxy-81 with MAC a2:a2:a2:a2:a7:a1 and requested IP via DHCP"

# Camera 82
ip link add onvif-proxy-82 link $INTERFACE address a2:a2:a2:a2:a7:a2 type macvlan mode bridge
ip link set onvif-proxy-82 up
dhclient onvif-proxy-82
echo "Created onvif-proxy-82 with MAC a2:a2:a2:a2:a7:a2 and requested IP via DHCP"

# Camera 83
ip link add onvif-proxy-83 link $INTERFACE address a2:a2:a2:a2:a7:a3 type macvlan mode bridge
ip link set onvif-proxy-83 up
dhclient onvif-proxy-83
echo "Created onvif-proxy-83 with MAC a2:a2:a2:a2:a7:a3 and requested IP via DHCP"

# Camera 84
ip link add onvif-proxy-84 link $INTERFACE address a2:a2:a2:a2:a7:a4 type macvlan mode bridge
ip link set onvif-proxy-84 up
dhclient onvif-proxy-84
echo "Created onvif-proxy-84 with MAC a2:a2:a2:a2:a7:a4 and requested IP via DHCP"

# Camera 85
ip link add onvif-proxy-85 link $INTERFACE address a2:a2:a2:a2:a7:a5 type macvlan mode bridge
ip link set onvif-proxy-85 up
dhclient onvif-proxy-85
echo "Created onvif-proxy-85 with MAC a2:a2:a2:a2:a7:a5 and requested IP via DHCP"

# Camera 86
ip link add onvif-proxy-86 link $INTERFACE address a2:a2:a2:a2:a7:a6 type macvlan mode bridge
ip link set onvif-proxy-86 up
dhclient onvif-proxy-86
echo "Created onvif-proxy-86 with MAC a2:a2:a2:a2:a7:a6 and requested IP via DHCP"

# Camera 87
ip link add onvif-proxy-87 link $INTERFACE address a2:a2:a2:a2:a7:a7 type macvlan mode bridge
ip link set onvif-proxy-87 up
dhclient onvif-proxy-87
echo "Created onvif-proxy-87 with MAC a2:a2:a2:a2:a7:a7 and requested IP via DHCP"

# Camera 88
ip link add onvif-proxy-88 link $INTERFACE address a2:a2:a2:a2:a7:a8 type macvlan mode bridge
ip link set onvif-proxy-88 up
dhclient onvif-proxy-88
echo "Created onvif-proxy-88 with MAC a2:a2:a2:a2:a7:a8 and requested IP via DHCP"

# Camera 89
ip link add onvif-proxy-89 link $INTERFACE address a2:a2:a2:a2:a7:a9 type macvlan mode bridge
ip link set onvif-proxy-89 up
dhclient onvif-proxy-89
echo "Created onvif-proxy-89 with MAC a2:a2:a2:a2:a7:a9 and requested IP via DHCP"

# Camera 90
ip link add onvif-proxy-90 link $INTERFACE address a2:a2:a2:a2:a7:b1 type macvlan mode bridge
ip link set onvif-proxy-90 up
dhclient onvif-proxy-90
echo "Created onvif-proxy-90 with MAC a2:a2:a2:a2:a7:b1 and requested IP via DHCP"

# Camera 91
ip link add onvif-proxy-91 link $INTERFACE address a2:a2:a2:a2:a7:b2 type macvlan mode bridge
ip link set onvif-proxy-91 up
dhclient onvif-proxy-91
echo "Created onvif-proxy-91 with MAC a2:a2:a2:a2:a7:b2 and requested IP via DHCP"

# Camera 92
ip link add onvif-proxy-92 link $INTERFACE address a2:a2:a2:a2:a7:b3 type macvlan mode bridge
ip link set onvif-proxy-92 up
dhclient onvif-proxy-92
echo "Created onvif-proxy-92 with MAC a2:a2:a2:a2:a7:b3 and requested IP via DHCP"

# Camera 93
ip link add onvif-proxy-93 link $INTERFACE address a2:a2:a2:a2:a7:b4 type macvlan mode bridge
ip link set onvif-proxy-93 up
dhclient onvif-proxy-93
echo "Created onvif-proxy-93 with MAC a2:a2:a2:a2:a7:b4 and requested IP via DHCP"

# Camera 94
ip link add onvif-proxy-94 link $INTERFACE address a2:a2:a2:a2:a7:b5 type macvlan mode bridge
ip link set onvif-proxy-94 up
dhclient onvif-proxy-94
echo "Created onvif-proxy-94 with MAC a2:a2:a2:a2:a7:b5 and requested IP via DHCP"

# Camera 95
ip link add onvif-proxy-95 link $INTERFACE address a2:a2:a2:a2:a7:b6 type macvlan mode bridge
ip link set onvif-proxy-95 up
dhclient onvif-proxy-95
echo "Created onvif-proxy-95 with MAC a2:a2:a2:a2:a7:b6 and requested IP via DHCP"

# Camera 96
ip link add onvif-proxy-96 link $INTERFACE address a2:a2:a2:a2:a7:b7 type macvlan mode bridge
ip link set onvif-proxy-96 up
dhclient onvif-proxy-96
echo "Created onvif-proxy-96 with MAC a2:a2:a2:a2:a7:b7 and requested IP via DHCP"

# NVR 6: 192.168.0.163 (16 cameras)
# Camera 97
ip link add onvif-proxy-97 link $INTERFACE address a2:a2:a2:a2:a8:a1 type macvlan mode bridge
ip link set onvif-proxy-97 up
dhclient onvif-proxy-97
echo "Created onvif-proxy-97 with MAC a2:a2:a2:a2:a8:a1 and requested IP via DHCP"

# Camera 98
ip link add onvif-proxy-98 link $INTERFACE address a2:a2:a2:a2:a8:a2 type macvlan mode bridge
ip link set onvif-proxy-98 up
dhclient onvif-proxy-98
echo "Created onvif-proxy-98 with MAC a2:a2:a2:a2:a8:a2 and requested IP via DHCP"

# Camera 99
ip link add onvif-proxy-99 link $INTERFACE address a2:a2:a2:a2:a8:a3 type macvlan mode bridge
ip link set onvif-proxy-99 up
dhclient onvif-proxy-99
echo "Created onvif-proxy-99 with MAC a2:a2:a2:a2:a8:a3 and requested IP via DHCP"

# Camera 100
ip link add onvif-proxy-100 link $INTERFACE address a2:a2:a2:a2:a8:a4 type macvlan mode bridge
ip link set onvif-proxy-100 up
dhclient onvif-proxy-100
echo "Created onvif-proxy-100 with MAC a2:a2:a2:a2:a8:a4 and requested IP via DHCP"

# Camera 101
ip link add onvif-proxy-101 link $INTERFACE address a2:a2:a2:a2:a8:a5 type macvlan mode bridge
ip link set onvif-proxy-101 up
dhclient onvif-proxy-101
echo "Created onvif-proxy-101 with MAC a2:a2:a2:a2:a8:a5 and requested IP via DHCP"

# Camera 102
ip link add onvif-proxy-102 link $INTERFACE address a2:a2:a2:a2:a8:a6 type macvlan mode bridge
ip link set onvif-proxy-102 up
dhclient onvif-proxy-102
echo "Created onvif-proxy-102 with MAC a2:a2:a2:a2:a8:a6 and requested IP via DHCP"

# Camera 103
ip link add onvif-proxy-103 link $INTERFACE address a2:a2:a2:a2:a8:a7 type macvlan mode bridge
ip link set onvif-proxy-103 up
dhclient onvif-proxy-103
echo "Created onvif-proxy-103 with MAC a2:a2:a2:a2:a8:a7 and requested IP via DHCP"

# Camera 104
ip link add onvif-proxy-104 link $INTERFACE address a2:a2:a2:a2:a8:a8 type macvlan mode bridge
ip link set onvif-proxy-104 up
dhclient onvif-proxy-104
echo "Created onvif-proxy-104 with MAC a2:a2:a2:a2:a8:a8 and requested IP via DHCP"

# Camera 105
ip link add onvif-proxy-105 link $INTERFACE address a2:a2:a2:a2:a8:a9 type macvlan mode bridge
ip link set onvif-proxy-105 up
dhclient onvif-proxy-105
echo "Created onvif-proxy-105 with MAC a2:a2:a2:a2:a8:a9 and requested IP via DHCP"

# Camera 106
ip link add onvif-proxy-106 link $INTERFACE address a2:a2:a2:a2:a8:b1 type macvlan mode bridge
ip link set onvif-proxy-106 up
dhclient onvif-proxy-106
echo "Created onvif-proxy-106 with MAC a2:a2:a2:a2:a8:b1 and requested IP via DHCP"

# Camera 107
ip link add onvif-proxy-107 link $INTERFACE address a2:a2:a2:a2:a8:b2 type macvlan mode bridge
ip link set onvif-proxy-107 up
dhclient onvif-proxy-107
echo "Created onvif-proxy-107 with MAC a2:a2:a2:a2:a8:b2 and requested IP via DHCP"

# Camera 108
ip link add onvif-proxy-108 link $INTERFACE address a2:a2:a2:a2:a8:b3 type macvlan mode bridge
ip link set onvif-proxy-108 up
dhclient onvif-proxy-108
echo "Created onvif-proxy-108 with MAC a2:a2:a2:a2:a8:b3 and requested IP via DHCP"

# Camera 109
ip link add onvif-proxy-109 link $INTERFACE address a2:a2:a2:a2:a8:b4 type macvlan mode bridge
ip link set onvif-proxy-109 up
dhclient onvif-proxy-109
echo "Created onvif-proxy-109 with MAC a2:a2:a2:a2:a8:b4 and requested IP via DHCP"

# Camera 110
ip link add onvif-proxy-110 link $INTERFACE address a2:a2:a2:a2:a8:b5 type macvlan mode bridge
ip link set onvif-proxy-110 up
dhclient onvif-proxy-110
echo "Created onvif-proxy-110 with MAC a2:a2:a2:a2:a8:b5 and requested IP via DHCP"

# Camera 111
ip link add onvif-proxy-111 link $INTERFACE address a2:a2:a2:a2:a8:b6 type macvlan mode bridge
ip link set onvif-proxy-111 up
dhclient onvif-proxy-111
echo "Created onvif-proxy-111 with MAC a2:a2:a2:a2:a8:b6 and requested IP via DHCP"

# Camera 112
ip link add onvif-proxy-112 link $INTERFACE address a2:a2:a2:a2:a8:b7 type macvlan mode bridge
ip link set onvif-proxy-112 up
dhclient onvif-proxy-112
echo "Created onvif-proxy-112 with MAC a2:a2:a2:a2:a8:b7 and requested IP via DHCP"

# Camera 113
ip link add onvif-proxy-113 link $INTERFACE address a2:a2:a2:a2:a9:a1 type macvlan mode bridge
ip link set onvif-proxy-113 up
dhclient onvif-proxy-113
echo "Created onvif-proxy-113 with MAC a2:a2:a2:a2:a9:a1 and requested IP via DHCP"

# Camera 114
ip link add onvif-proxy-114 link $INTERFACE address a2:a2:a2:a2:a9:a2 type macvlan mode bridge
ip link set onvif-proxy-114 up
dhclient onvif-proxy-114
echo "Created onvif-proxy-114 with MAC a2:a2:a2:a2:a9:a2 and requested IP via DHCP"

# Camera 115
ip link add onvif-proxy-115 link $INTERFACE address a2:a2:a2:a2:a9:a3 type macvlan mode bridge
ip link set onvif-proxy-115 up
dhclient onvif-proxy-115
echo "Created onvif-proxy-115 with MAC a2:a2:a2:a2:a9:a3 and requested IP via DHCP"

# Camera 116
ip link add onvif-proxy-116 link $INTERFACE address a2:a2:a2:a2:a9:a4 type macvlan mode bridge
ip link set onvif-proxy-116 up
dhclient onvif-proxy-116
echo "Created onvif-proxy-116 with MAC a2:a2:a2:a2:a9:a4 and requested IP via DHCP"

# Camera 117
ip link add onvif-proxy-117 link $INTERFACE address a2:a2:a2:a2:a9:a5 type macvlan mode bridge
ip link set onvif-proxy-117 up
dhclient onvif-proxy-117
echo "Created onvif-proxy-117 with MAC a2:a2:a2:a2:a9:a5 and requested IP via DHCP"

# Camera 118
ip link add onvif-proxy-118 link $INTERFACE address a2:a2:a2:a2:a9:a6 type macvlan mode bridge
ip link set onvif-proxy-118 up
dhclient onvif-proxy-118
echo "Created onvif-proxy-118 with MAC a2:a2:a2:a2:a9:a6 and requested IP via DHCP"

# Camera 119
ip link add onvif-proxy-119 link $INTERFACE address a2:a2:a2:a2:a9:a7 type macvlan mode bridge
ip link set onvif-proxy-119 up
dhclient onvif-proxy-119
echo "Created onvif-proxy-119 with MAC a2:a2:a2:a2:a9:a7 and requested IP via DHCP"

# Camera 120
ip link add onvif-proxy-120 link $INTERFACE address a2:a2:a2:a2:a9:a8 type macvlan mode bridge
ip link set onvif-proxy-120 up
dhclient onvif-proxy-120
echo "Created onvif-proxy-120 with MAC a2:a2:a2:a2:a9:a8 and requested IP via DHCP"

# Camera 121
ip link add onvif-proxy-121 link $INTERFACE address a2:a2:a2:a2:a9:a9 type macvlan mode bridge
ip link set onvif-proxy-121 up
dhclient onvif-proxy-121
echo "Created onvif-proxy-121 with MAC a2:a2:a2:a2:a9:a9 and requested IP via DHCP"

# Camera 122
ip link add onvif-proxy-122 link $INTERFACE address a2:a2:a2:a2:a9:b1 type macvlan mode bridge
ip link set onvif-proxy-122 up
dhclient onvif-proxy-122
echo "Created onvif-proxy-122 with MAC a2:a2:a2:a2:a9:b1 and requested IP via DHCP"

# Camera 123
ip link add onvif-proxy-123 link $INTERFACE address a2:a2:a2:a2:a9:b2 type macvlan mode bridge
ip link set onvif-proxy-123 up
dhclient onvif-proxy-123
echo "Created onvif-proxy-123 with MAC a2:a2:a2:a2:a9:b2 and requested IP via DHCP"

# Camera 124
ip link add onvif-proxy-124 link $INTERFACE address a2:a2:a2:a2:a9:b3 type macvlan mode bridge
ip link set onvif-proxy-124 up
dhclient onvif-proxy-124
echo "Created onvif-proxy-124 with MAC a2:a2:a2:a2:a9:b3 and requested IP via DHCP"

# Camera 125
ip link add onvif-proxy-125 link $INTERFACE address a2:a2:a2:a2:a9:b4 type macvlan mode bridge
ip link set onvif-proxy-125 up
dhclient onvif-proxy-125
echo "Created onvif-proxy-125 with MAC a2:a2:a2:a2:a9:b4 and requested IP via DHCP"

# Camera 126
ip link add onvif-proxy-126 link $INTERFACE address a2:a2:a2:a2:a9:b5 type macvlan mode bridge
ip link set onvif-proxy-126 up
dhclient onvif-proxy-126
echo "Created onvif-proxy-126 with MAC a2:a2:a2:a2:a9:b5 and requested IP via DHCP"

# Camera 127
ip link add onvif-proxy-127 link $INTERFACE address a2:a2:a2:a2:a9:b6 type macvlan mode bridge
ip link set onvif-proxy-127 up
dhclient onvif-proxy-127
echo "Created onvif-proxy-127 with MAC a2:a2:a2:a2:a9:b6 and requested IP via DHCP"

# Camera 128
ip link add onvif-proxy-128 link $INTERFACE address a2:a2:a2:a2:a9:b7 type macvlan mode bridge
ip link set onvif-proxy-128 up
dhclient onvif-proxy-128
echo "Created onvif-proxy-128 with MAC a2:a2:a2:a2:a9:b7 and requested IP via DHCP"

echo "All virtual network interfaces created successfully!"
echo ""
echo "The virtual interfaces will now request IP addresses via DHCP."
echo "You can set static IP reservations for these MAC addresses in your Unifi router."
echo ""
echo "You can now start the onvif-server with:"
echo "bash start-all-cameras.sh"
echo ""
echo "Note: These virtual network settings will be lost when you reboot the system."
echo "You'll need to run this script again after each reboot."

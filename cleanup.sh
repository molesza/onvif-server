#!/bin/bash

# This script removes existing virtual network interfaces

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

echo "Removing existing virtual network interfaces..."

# Remove rtsp2onvif interfaces
for i in {0..200}; do
  if ip link show rtsp2onvif_$i > /dev/null 2>&1; then
    echo "Removing rtsp2onvif_$i"
    ip link delete rtsp2onvif_$i
  fi
done

# Remove onvif-proxy interfaces (in case they exist)
for i in {1..200}; do
  if ip link show onvif-proxy-$i > /dev/null 2>&1; then
    echo "Removing onvif-proxy-$i"
    ip link delete onvif-proxy-$i
  fi
done

echo "All virtual network interfaces removed successfully!"

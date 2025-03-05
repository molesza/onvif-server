# Project Brief: Virtual Onvif Server

## Overview
The Virtual Onvif Server is a tool that takes existing RTSP streams and builds virtual Onvif devices for them, allowing the streams to be consumed by Onvif-compatible clients. It was originally developed to work around limitations in the third-party support of Unifi Protect.

## Core Requirements

1. **Create Virtual Onvif Devices**: Transform existing RTSP streams into virtual Onvif devices that can be discovered and used by Onvif-compatible clients.

2. **Support for Unifi Protect**: Specifically address limitations in Unifi Protect 5.0's third-party camera support, which only supports cameras with a single high and low-quality stream.

3. **Split Multi-Channel Devices**: Allow multi-channel Onvif devices (like video recorders that output multiple cameras) to be split into multiple virtual Onvif devices that work well with Unifi Protect.

4. **Support for Regular RTSP Streams**: Enable wrapping of regular RTSP streams as Onvif devices, even if they don't come from an Onvif-compatible source.

5. **Configurable Virtual Devices**: Allow users to configure the properties of the virtual Onvif devices, including resolution, framerate, bitrate, and quality settings.

6. **Network Virtualization**: Support for creating virtual network interfaces with unique MAC addresses to properly work with Unifi Protect.

## Goals

1. **Simplicity**: Provide a simple solution that can be run on low-power devices like a Raspberry Pi.

2. **Flexibility**: Support various RTSP stream sources and configurations.

3. **Compatibility**: Ensure compatibility with Onvif Profile S (Live Streaming) standards.

4. **Containerization**: Provide Docker support for easy deployment.

## Constraints

1. **Limited Onvif Support**: Currently only implements Onvif Profile S (Live Streaming) with limited functionality.

2. **Network Configuration**: Requires proper network configuration, including virtual network interfaces with unique MAC addresses.

3. **Platform Requirements**: Requires Node.js v16 or higher and Raspberry OS 11 (Bullseye) or newer for Raspberry Pi deployments.

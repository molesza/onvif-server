# Project Brief: Virtual Onvif Server

## Overview
The Virtual Onvif Server is a solution designed to overcome limitations in third-party support for multi-channel camera systems, particularly with Unifi Protect. It creates virtual Onvif devices from existing RTSP streams, allowing them to be consumed by Onvif-compatible clients.

## Core Problem
Unifi Protect 5.0 introduced support for third-party cameras but has limitations - it only properly supports cameras with a single high and low-quality stream. Video recorders that output multiple cameras (like Hikvision/Dahua XVR) or cameras with multiple internal cameras are not properly supported.

## Solution
This tool runs on a Raspberry Pi or similar device to split up a multi-channel Onvif device into multiple virtual Onvif devices that work well with Unifi Protect 5.0. Each virtual device appears as a separate camera in Unifi Protect.

## Key Features
- Creates virtual Onvif devices from existing RTSP streams
- Supports Profile S (Live Streaming)
- Allows multi-channel NVRs to be used with Unifi Protect
- Configurable for different camera setups
- Supports multiple NVRs with many cameras

## Technical Requirements
- Raspberry OS 11 (Bullseye) or newer
- Node.js v16 or higher
- Network configuration with virtual interfaces
- YAML-based configuration

## Current Implementation
The system has been configured for multiple NVRs (192.168.0.207, 192.168.0.49, 192.168.0.63, 192.168.0.79, 192.168.0.96, 192.168.0.163) with a total of 128 cameras. Each camera is configured as a separate virtual Onvif device with unique MAC addresses, ports, and network settings.

## Project Goals
1. Provide a reliable bridge between multi-channel NVRs and Unifi Protect
2. Ensure stable video streaming with proper configuration
3. Make setup and maintenance straightforward
4. Support a large number of cameras across multiple NVRs

#!/bin/bash

# This script combines all YAML files in the configs directory into a single config.yaml file
# and ensures there are no duplicate port numbers

# Create a temporary directory
mkdir -p temp

# Initialize port tracking arrays
declare -A rtsp_ports
declare -A snapshot_ports
declare -A server_ports
next_rtsp_port=8554
next_snapshot_port=9000
next_server_port=8001

# Process each config file separately first to fix port conflicts
for file in configs/*.yaml; do
  echo "Pre-processing $file for port conflicts..."
  base_name=$(basename "$file")
  
  # Skip the first line (onvif:) and process the rest
  tail -n +2 "$file" > "temp/$base_name"
  
  # Fix port conflicts in the file
  while IFS= read -r line; do
    # Check for rtsp port
    if [[ $line =~ rtsp:\ ([0-9]+) ]]; then
      port=${BASH_REMATCH[1]}
      if [[ -n "${rtsp_ports[$port]}" ]]; then
        # Port conflict found, replace with next available port
        new_port=$next_rtsp_port
        next_rtsp_port=$((next_rtsp_port + 2))
        sed -i "s/rtsp: $port/rtsp: $new_port/g" "temp/$base_name"
        echo "  Fixed RTSP port conflict: $port -> $new_port"
        rtsp_ports[$new_port]=1
      else
        rtsp_ports[$port]=1
        if (( port >= next_rtsp_port )); then
          next_rtsp_port=$((port + 2))
        fi
      fi
    fi
    
    # Check for snapshot port
    if [[ $line =~ snapshot:\ ([0-9]+) ]]; then
      port=${BASH_REMATCH[1]}
      if [[ -n "${snapshot_ports[$port]}" ]]; then
        # Port conflict found, replace with next available port
        new_port=$next_snapshot_port
        next_snapshot_port=$((next_snapshot_port + 2))
        sed -i "s/snapshot: $port/snapshot: $new_port/g" "temp/$base_name"
        echo "  Fixed snapshot port conflict: $port -> $new_port"
        snapshot_ports[$new_port]=1
      else
        snapshot_ports[$port]=1
        if (( port >= next_snapshot_port )); then
          next_snapshot_port=$((port + 2))
        fi
      fi
    fi
    
    # Check for server port
    if [[ $line =~ server:\ ([0-9]+) ]]; then
      port=${BASH_REMATCH[1]}
      if [[ -n "${server_ports[$port]}" ]]; then
        # Port conflict found, replace with next available port
        new_port=$next_server_port
        next_server_port=$((next_server_port + 1))
        sed -i "s/server: $port/server: $new_port/g" "temp/$base_name"
        echo "  Fixed server port conflict: $port -> $new_port"
        server_ports[$new_port]=1
      else
        server_ports[$port]=1
        if (( port >= next_server_port )); then
          next_server_port=$((port + 1))
        fi
      fi
    fi
  done < "temp/$base_name"
done

# Create the output file with the onvif header
echo "onvif:" > config.yaml

# Combine all processed files
for file in temp/*.yaml; do
  echo "Adding processed $file to combined config..."
  cat "$file" >> config.yaml
done

# Clean up
rm -rf temp

echo "Combined configuration created in config.yaml with no port conflicts"

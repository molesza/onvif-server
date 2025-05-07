#!/bin/bash

# Script to create additional macvlan interfaces for ONVIF server
# Preserves existing interfaces and creates new ones starting from a specified index

# Function to validate IP address format
validate_ip() {
    local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# Function to validate subnet mask format
validate_subnet() {
    local subnet=$1
    # Accept both formats: "24" or "/24"
    if [[ $subnet =~ ^/[0-9]{1,2}$ ]]; then
        # Remove the leading slash if present
        subnet="${subnet:1}"
    fi

    if [[ $subnet =~ ^[0-9]{1,2}$ ]] && [ "$subnet" -ge 0 ] && [ "$subnet" -le 32 ]; then
        echo "$subnet"
        return 0
    else
        return 1
    fi
}

# Function to validate interface exists
validate_interface() {
    local interface=$1
    if ip link show "$interface" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to increment IP address
increment_ip() {
    local ip=$1
    local increment=$2

    IFS='.' read -r -a ip_array <<< "$ip"

    # Convert IP to a single number
    local ip_num=$(( (ip_array[0] << 24) + (ip_array[1] << 16) + (ip_array[2] << 8) + ip_array[3] ))

    # Add the increment
    ip_num=$((ip_num + increment))

    # Convert back to dotted decimal
    local new_ip
    new_ip=$(( (ip_num >> 24) & 255 ))
    new_ip="$new_ip.$(( (ip_num >> 16) & 255 ))"
    new_ip="$new_ip.$(( (ip_num >> 8) & 255 ))"
    new_ip="$new_ip.$(( ip_num & 255 ))"

    echo "$new_ip"
}

# Function to generate MAC address with proper format
generate_mac() {
    local index=$1

    # MAC addresses can only have values from 00 to FF in each byte
    # For values 1-255, use the last byte
    if [ "$index" -le 255 ]; then
        printf "a2:a2:a2:a2:a2:%02x" "$index"
    else
        # For values > 255, use the 5th byte for overflow
        local byte5=$(( (index / 256) % 256 ))
        local byte6=$(( index % 256 ))
        printf "a2:a2:a2:a2:%02x:%02x" "$byte5" "$byte6"
    fi
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "===== ONVIF Server Additional MacVLAN Interface Creator ====="
echo "This script will create additional virtual network interfaces for your ONVIF server"
echo "while preserving existing interfaces."
echo ""

# Get parent interface
while true; do
    read -p "Enter the parent network interface (e.g., eth0): " parent_interface
    if validate_interface "$parent_interface"; then
        break
    else
        echo "Error: Interface $parent_interface does not exist. Please enter a valid interface."
    fi
done

# Get base IP address
while true; do
    read -p "Enter the base IP address (e.g., 192.168.1.100): " base_ip
    if validate_ip "$base_ip"; then
        break
    else
        echo "Error: Invalid IP address format. Please use format like 192.168.1.100"
    fi
done

# Get subnet mask
while true; do
    read -p "Enter the subnet mask (e.g., 24 or /24): " subnet_input
    subnet_mask=$(validate_subnet "$subnet_input")
    if [ $? -eq 0 ]; then
        break
    else
        echo "Error: Invalid subnet mask. Please enter a number between 0 and 32."
    fi
done

# Get gateway IP
while true; do
    read -p "Enter the gateway IP address: " gateway_ip
    if validate_ip "$gateway_ip"; then
        break
    else
        echo "Error: Invalid gateway IP address format. Please use format like 192.168.1.1"
    fi
done

# Get starting index
while true; do
    read -p "Enter the starting index for new interfaces (e.g., 33 to preserve interfaces 1-32): " start_index
    if [[ "$start_index" =~ ^[0-9]+$ ]] && [ "$start_index" -gt 0 ]; then
        break
    else
        echo "Error: Please enter a positive number."
    fi
done

# Get number of interfaces to create
while true; do
    read -p "Enter the number of additional interfaces to create: " num_interfaces
    if [[ "$num_interfaces" =~ ^[0-9]+$ ]] && [ "$num_interfaces" -gt 0 ]; then
        if [ "$((start_index + num_interfaces - 1))" -gt 255 ]; then
            echo "Warning: Creating interfaces beyond index 255 may cause issues with MAC address assignment."
            echo "The script will handle this by using a different MAC address format for indices > 255."
            read -p "Do you want to continue? (y/n): " continue_choice
            if [[ "$continue_choice" =~ ^[Yy]$ ]]; then
                break
            fi
        else
            break
        fi
    else
        echo "Error: Please enter a positive number."
    fi
done

echo ""
echo "Creating $num_interfaces additional interfaces starting from index $start_index..."
echo ""

# Apply sysctl settings to prevent MAC address conflicts
echo "Applying sysctl settings to prevent MAC address conflicts..."
sysctl -w net.ipv4.conf.all.arp_ignore=1
sysctl -w net.ipv4.conf.all.arp_announce=2

# Create the interfaces
for i in $(seq "$start_index" "$((start_index + num_interfaces - 1))"); do
    # Generate MAC address with proper format
    mac_address=$(generate_mac "$i")

    # Generate interface name
    interface_name="onvif-proxy-$i"

    # Generate IP address (adjust the offset to account for starting index)
    ip_address=$(increment_ip "$base_ip" $((i-start_index)))

    # Check if interface already exists
    if ip link show "$interface_name" &> /dev/null; then
        echo "Interface $interface_name already exists, skipping..."
        continue
    fi

    echo "Creating interface $interface_name with MAC $mac_address and IP $ip_address/$subnet_mask"

    # Create the macvlan interface
    ip link add "$interface_name" link "$parent_interface" address "$mac_address" type macvlan mode bridge

    # Assign static IP address
    ip addr add "$ip_address/$subnet_mask" dev "$interface_name" 2>/dev/null || true

    # Bring the interface up
    ip link set "$interface_name" up

    # Remove any existing rules for this IP
    ip rule del from "$ip_address" 2>/dev/null || true

    # Add default route through gateway for this interface
    ip route add default via "$gateway_ip" dev "$interface_name" table "$((100+i))" 2>/dev/null || true
    ip rule add from "$ip_address" table "$((100+i))" 2>/dev/null || true
done

echo ""
echo "All additional interfaces created successfully!"
echo ""
echo "To make these changes persistent across reboots, you should add these commands"
echo "to a startup script or use a network configuration manager like NetworkManager or systemd-networkd."
echo ""
echo "Created interfaces:"
ip addr | grep -A 2 "onvif-proxy-"

# Function to ensure any files created by this script have proper ownership
fix_file_ownership() {
    local file="$1"
    if [ -f "$file" ]; then
        # Get the original user who ran the script with sudo
        original_user=""
        if [ -n "$SUDO_USER" ]; then
            original_user="$SUDO_USER"
        else
            # If SUDO_USER is not set, try to get the user who invoked sudo
            original_user=$(logname 2>/dev/null || echo "")
        fi

        # Change ownership of the file back to the original user if we can determine who that is
        if [ -n "$original_user" ]; then
            echo "Changing ownership of $file back to $original_user"
            chown "$original_user:$original_user" "$file"
        fi
    fi
}

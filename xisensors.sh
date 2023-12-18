#!/bin/bash

# Bluetooth device address
device_address="A4:C1:38:74:43:52"

# Function to convert hex to decimal
hex_to_dec() {
    echo $((16#$1))
}

# Function to convert hex to decimal and divide by 100
hex_to_dec_div100() {
    echo "scale=2; $((16#$1)) / 100" | bc
}

# Function to convert hex to decimal and divide by 1000
hex_to_dec_div1000() {
    echo "scale=3; $((16#$1)) / 1000" | bc
}

# Function to read data from Bluetooth device
read_from_device() {
    # Read from the Bluetooth device with a timeout of 15 seconds
    bt_output=$(timeout 15 gatttool -b "$device_address" --char-write-req --handle='0x0038' --value="0100" --listen | awk '/Notification handle = 0x0036 value:/,0')

    # Check if the output is empty
    if [ -z "$bt_output" ]; then
        echo "Error: Failed to read from device."
        return 1
    fi

    # Extract the first occurrence of the raw values of Notification handle = 0x0036
    raw_values=$(echo "$bt_output" | grep "Notification handle = 0x0036 value:" | cut -d ' ' -f6- | head -n 1)

    # Split the raw values into separate variables
    read val1 val2 val3 val4 val5 <<< $(echo $raw_values)

    # Concatenate values for Teplota and Baterie
    teplota_hex="$val2$val1"
    baterie_hex="$val5$val4"

    # Combine all three values into one line
    echo "Teplota:$(hex_to_dec_div100 $teplota_hex) Vlhkost:$(hex_to_dec $val3) Baterie:$(hex_to_dec_div1000 $baterie_hex)"
}

# Execute the function
read_from_device

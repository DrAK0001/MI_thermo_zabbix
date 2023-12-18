# MI_thermo_zabbix
Xiaomi Mi Temperature and Humidity Monitor | Bluetooth | Data to Zabbix

Description

This script is designed to read data from a specific Bluetooth device and output the values for temperature ("Teplota"), humidity ("Vlhkost"), and battery level ("Baterie"). It's tailored for integration with Zabbix monitoring software using Zabbix Agent's custom UserParameter functionality. The script outputs all three values in a single line, formatted for easy parsing by Zabbix.
User Guide
Prerequisites

    A Unix-based system with gatttool installed (commonly available in BlueZ package).
    A Zabbix monitoring setup with Zabbix Agent (or Zabbix Agent 2) installed on the same system as the script.

Installation

    Script Setup
        Place the script in a suitable directory, for example, /usr/local/bin/xisensor.sh.
        Ensure the script has execute permissions:

        bash

    chmod +x /usr/local/bin/xisensor.sh

Zabbix Agent Configuration

    Edit the Zabbix Agent configuration file (usually located at /etc/zabbix/zabbix_agentd.conf).
    Add a new UserParameter that points to the script:

    javascript

UserParameter=custom.sensor_values,/usr/local/bin/xisensor.sh

Restart Zabbix Agent to apply the changes:

        sudo systemctl restart zabbix-agent

Usage in Zabbix

    Create a Master Item
        In Zabbix frontend, navigate to Configuration > Hosts.
        Select the relevant host and go to the Items section.
        Create a new item with the following configuration:
            Name: Sensor Values
            Type: Zabbix agent
            Key: custom.sensor_values
            Type of Information: Text

    Create Dependent Items
        For "Teplota", "Vlhkost", and "Baterie", create separate Dependent Items linked to the master item.
        Use preprocessing with regular expressions to extract each value:
            For Teplota: Pattern Teplota:(\d+\.\d+), Output \1.
            For Vlhkost: Pattern Vlhkost:(\d+), Output \1.
            For Baterie: Pattern Baterie:(\d+\.\d+), Output \1.

    Data Collection and Monitoring
        Zabbix will collect data according to the item's configuration.
        You can create graphs, triggers, and other monitoring elements based on these items.

Notes

    Ensure the Bluetooth device address in the script matches your actual device.
    The script and the Zabbix Agent must have necessary permissions to execute and access Bluetooth tools and devices.
    Regular expressions in Zabbix preprocessing must match the script's output format exactly.
    If changes are made to the script's output format, corresponding adjustments in Zabbix item preprocessing steps are required.

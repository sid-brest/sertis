#!/usr/bin/env python3

import ipaddress

# Define the gateway IPv6 address and the interface name
gateway_ip = 'fe80::1'
interface_name = 'eth3'

# Define the metric value
metric = 1

# Load the list of IPv6 addresses in CIDR notation from a file
with open('cidr_list_ipv6.txt', 'r') as f:
    cidr_list = [line.strip() for line in f]

# Generate the ip route add commands
commands = []
for cidr in cidr_list:
    network = ipaddress.ip_network(cidr)
    command = f"ip -6 route add {cidr} via {gateway_ip} dev {interface_name} proto unspec metric {metric} onlink"
    commands.append(command)

# Save the commands to a bash script file
with open('ip_routes_ipv6.sh', 'w') as f:
    for command in commands:
        f.write(f"{command}\n")

# cat ip_routes.sh | ssh -p 2222 root@86.57.251.161 'bash -s'
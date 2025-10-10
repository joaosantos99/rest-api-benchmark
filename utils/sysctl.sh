#!/usr/bin/env bash
set -e

# File descriptors
ulimit -n 1048576

# Ephemeral ports & sockets
sudo sysctl -w net.ipv4.ip_local_port_range="1024 65535"
sudo sysctl -w net.core.somaxconn=65535
sudo sysctl -w net.core.netdev_max_backlog=65535
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=262144
sudo sysctl -w net.ipv4.tcp_fin_timeout=15
sudo sysctl -w net.ipv4.tcp_tw_reuse=1
sudo sysctl -w net.ipv4.tcp_mtu_probing=1

# Allow many connections
sudo sysctl -w fs.file-max=2097152

# Docker bridge (optional) – or use host networking for k6
# sudo sysctl -w net.ipv4.ip_forward=1

#!/bin/bash

echo "#### Server info ####"
echo ""
echo "Servername: $(hostname)"
echo "IP: $(hostname -I | col1)"
echo "Betriebssystem: $(grep ^PRETTY /etc/os-release | cut -d = -f2 | tr -d '"')"
echo ""
echo ""

echo "#### Festplattenstatus ####"
echo ""
df -h
echo ""
echo ""

echo "#### Blockgeräte ####"
echo ""
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT

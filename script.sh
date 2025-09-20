#!/bin/bash

# Variables
RG="abc-rg"
AGW="abc-agw"
BACKEND_POOL="backendPool"   
VM1_IP="4.155.148.184"             
VM2_IP="10.0.2.5"            

# Check input
if [ "$1" != "vm1" ] && [ "$1" != "vm2" ]; then
  echo "Usage: $0 [vm1|vm2]"
  exit 1
fi

if [ "$1" == "vm1" ]; then
  TARGET_IP=$VM1_IP
  echo "Switching Application Gateway backend pool to VM1 ($VM1_IP)..."
else
  TARGET_IP=$VM2_IP
  echo "Switching Application Gateway backend pool to VM2 ($VM2_IP)..."
fi




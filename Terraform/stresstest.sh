#!/bin/bash
sudo yum install -y stress
stress --cpu 4 --timeout 300s

stress --cpu 16 --timeout 3000s
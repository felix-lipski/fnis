#!/bin/bash
parted /dev/sda -- mklabel gpt
echo "partitioned"

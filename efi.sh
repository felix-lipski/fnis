#!/bin/bash
echo "partitioning..."
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB -2GiB
parted /dev/sda -- mkpart primary linux-swap -2GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 esp on
echo "partitioned successfully"

echo "formatting..."
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3
echo "formatted successfully"

echo "mounting..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2
echo "mounted successfully"

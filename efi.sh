#!/bin/bash
read -p "How many swap gigabytes do you want, sir?: " swap_size
echo "Partitioning..."
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB "-${swap_size}GiB"
parted /dev/sda -- mkpart primary linux-swap "-${swap_size}GiB" 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 esp on

echo "Formatting..."
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

echo "Mounting..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2

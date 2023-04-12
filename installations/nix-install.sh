#!/bin/sh
PARTITION=$1

################################################################################
## Partitioning (UEFI - GPT)
################################################################################

# Create a GPT partition table.
parted $PARTITION -- mklabel gpt

# Add the root partition. This will fill the disk except for the end part,
# where the swap will live, and the space left in front (512MiB) which will
# be used by the boot partition.
parted $PARTITION -- mkpart primary 512MiB -2GiB

# Next, add a swap partition. The size required will vary according to needs,
# here a 2GiB one is created.
parted $PARTITION -- mkpart primary linux-swap -2GiB 100%

# Finally, the boot partition. NixOS by default uses
# the ESP (EFI system partition) as its /boot partition.
# It uses the initially reserved 512MiB at the start of the disk. 
parted $PARTITION -- mkpart ESP fat32 1MiB 512MiB
parted $PARTITION -- set 3 esp on

################################################################################
## Formatting
################################################################################

# For initialising Ext4 partitions: mkfs.ext4. It is recommended that you
# assign a unique symbolic label to the file system using the option -L label,
# since this makes the file system configuration independent from device
# changes.
mkfs.ext4 -L nixos "${PARTITION}1"

# For creating swap partitions: mkswap. Again it’s recommended to assign a
# label to the swap partition: -L label.
mkswap -L swap "${PARTITION}2"

# For creating boot partitions: mkfs.fat. Again it’s recommended to assign a
# label to the boot partition: -n label.
mkfs.fat -F 32 -n boot "${PARTITION}3"

################################################################################
## Installing
################################################################################

# Mount the target file system on which NixOS should be installed on /mnt.
mount /dev/disk/by-label/nixos /mnt

# Mount the boot file system on /mnt/boot.
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# If your machine has a limited amount of memory, you may want to activate swap
# devices now (swapon device). The installer (or rather, the build actions that
# it may spawn) may need quite a bit of RAM, depending on your configuration.
swapon "${PARTITION}2"

# You now need to create a file /mnt/etc/nixos/configuration.nix that specifies
# the intended configuration of the system. 
nixos-generate-config --root /mnt

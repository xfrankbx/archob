# Update Pacman Mirrors
pacman -Syyy

# Define Variables
Disk="vda"

# Partition disk as EFI
(
# Create GPT Label
echo g;

# Create EFI Partition
echo n;
echo 1;
echo;
echo +300M;

# Create SWAP Partition
echo n;
echo 2;
echo;
echo +2G;

# Create Root partition
echo n;
echo 3;
echo;
echo;

# Change Partition type to EFI
echo t;
echo 1;
echo 1;

# Change Partition type to SWAP
echo t;
echo 2;
echo 19;

# Write changes to disk
echo w;
) | sudo fdisk -w always -W always /dev/${Disk}

# Format Disk
mkfs.fat -F32 /dev/${Disk}1
mkfs.ext4 /dev/${Disk}3
mkswap /dev/${Disk}2

# Mount Partitions
mount /dev/${Disk}3 /mnt
swapon /dev/${Disk}2

# Install software
echo y | pacman -S archlinux-keyring
echo y | pacstrap /mnt base linux linux-firmware openssh nano vim networkmanager python3 sudo git bash-completion wget curl grub efibootmgr dosfstools os-prober mtools git fakeroot binutils patch autoconf automake pkg-config gcc make asciidoc

# Generate fstab file
genfstab -U -p /mnt >> /mnt/etc/fstab

# Set Hostname
echo "archlinux" > /mnt/etc/hostname

# Set Keymap
echo "KEYMAP=us" > /mnt/etc/vconsole.conf

# Set TimeZone
ln -sf /mnt/usr/share/zoneinfo/America/New_York /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc --localtime

# Set Lang
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
echo "LC_COLLATE=C" >> /mnt/etc/locale.conf
sed -i '/#en_US.UTF-8/s/^#//g' /mnt/etc/locale.gen
sed -i '/#en_US ISO-8859-1/s/^#//g' /mnt/etc/locale.gen
arch-chroot /mnt locale-gen

# Update Pacman repo, Enable NetworkManager and SSH, Setup Users
(
echo pacman -Syu;
echo systemctl enable NetworkManager;
echo systemctl enable sshd;
echo groupadd -g 1001 frank;
echo useradd -d /home/frank -s /bin/bash -u 1001 -g 1001 -m frank;
echo usermod -p '$(python -c "import crypt; print(crypt.crypt(\"fda123\"))")' root;
echo usermod -p '$(python -c "import crypt; print(crypt.crypt(\"fda123\"))")' frank;
) | arch-chroot /mnt

# Setup sudo for Frank
echo "frank   ALL=(ALL:ALL) NOPASSWD:ALL" > /mnt/etc/sudoers.d/frank

(
echo mkdir /boot/EFI;
echo mount /dev/${Disk}1 /boot/EFI;
echo grub-install --target=x86_64-efi  --bootloader-id=grub_uefi --recheck;
echo umount /boot/EFI;
echo grub-mkconfig -o /boot/grub/grub.cfg
) | arch-chroot /mnt


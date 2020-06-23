#!/bin/bash

(
echo g;
echo n;
echo 1;
echo;
echo +31M;
echo n;
echo 2;
echo;
echo +512M;
echo n;
echo 3;
echo;
echo +2G;
echo n;
echo 4;
echo;
echo;
echo t;
echo 1;
echo 4;
echo t;
echo 3;
echo 19;
echo w;
) | sudo fdisk -w always -W always /dev/vda

partprobe /dev/vda

mkfs.ext4 /dev/vda2;
mkfs.ext4 /dev/vda4;
mkswap /dev/vda3;

mount /dev/vda4 /mnt
mkdir /mnt/boot
mount /dev/vda2 /mnt/boot

echo y | pacman -S archlinux-keyring
echo y | pacstrap /mnt base base-devel linux openssh nano grub os-prober vim networkmanager python3 sudo git bash-completion wget

echo "archlinux" > /mnt/etc/hostname
echo "KEYMAP=us" > /mnt/etc/vconsole.conf

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
echo "LC_COLLATE=C" >> /mnt/etc/locale.conf
sed -i '/#en_US.UTF-8/s/^#//g' /mnt/etc/locale.gen
genfstab -U -p /mnt > /mnt/etc/fstab

(
echo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime;
echo locale-gen;
echo hwclock --systohc --localtime;
echo mkdir /boot/grub;
echo grub-install /dev/vda;
echo grub-mkconfig -o /boot/grub/grub.cfg;
echo systemctl enable NetworkManager;
echo systemctl enable sshd;
echo groupadd -g 1000 frank;
echo useradd -d /home/frank -s /bin/bash -u 1000 -g 1000 -m frank;
echo usermod -p '$(python -c "import crypt; print(crypt.crypt(\"fda123\"))")' root;
echo usermod -p '$(python -c "import crypt; print(crypt.crypt(\"fda123\"))")' frank;
) | arch-chroot /mnt

sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /mnt/etc/ssh/sshd_config
echo "frank   ALL=(ALL:ALL) NOPASSWD:ALL" > /mnt/etc/sudoers.d/frank
umount /mnt/boot /mnt

#!/bin/bash


mkfs.fat -F32 /dev/sda1;
mkfs.ext4 /dev/sda3;
mkswap /dev/sda2;

mount /dev/sda3 /mnt
swapon /dev/sda2

mkdir -p /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI

echo y | pacman -S archlinux-keyring
echo y | pacstrap /mnt base base-devel linux openssh nano vim grub os-prober networkmanager sudo git python3 efibootmgr dosfstools mtools

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
echo grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck;
echo grub-mkconfig -o /boot/grub/grub.cfg;
echo systemctl enable NetworkManager;
echo systemctl enable sshd;
echo groupadd -g 1000 frank;
echo useradd -d /home/frank -s /bin/bash -u 1000 -g 1000 -m frank;
echo usermod -p '$(python -c "import crypt; print(crypt.crypt(\"fda123\"))")' root;
echo usermod -p '$(python -c "import crypt; print(crypt.crypt(\"fda123\"))")' frank;
) | arch-chroot /mnt

echo "frank   ALL=(ALL:ALL) NOPASSWD:ALL" > /mnt/etc/sudoers.d/frank
umount /mnt/boot/EFI /mnt

packages=(
	# Base Linux
	base
  	base-devel

	# Linux kernel
	amd-ucode
	linux
 	linux-firmware
	linux-headers
  	
	# OSTree dependencies
	efibootmgr
	grub
	ostree
	which

  	# Desktop dependencies
   	btrfs-progs
    	htop
     	iwd
  	nano
   	openssh
    	smartmontools
     	uwsm
	vim
	wget
  	wireless_tools
	wpa_supplicant
 	xdg-user-dirs
	xdg-utils

  	# Hyprland dependencies
   	dolphin
   	dunst
    	grim
  	hyprland
	kitty
 	polkit-kde-agent
 	qt5-wayland
	qt6-wayland
 	slurp
	wofi
	xdg-desktop-portal-hyprland

  	# Graphics drivers
  	libva-mesa-driver
  	mesa
  	vulkan-radeon
  	xf86-video-amdgpu
  	xf86-video-ati
  	xorg-xinit
  	xorg-server

  	# Greeter
  	sddm

  	# Audio Config
   	gst-plugin-pipewire
    	libpulse
  	pipewire
	pipewire-alsa
	pipewire-jack
	pipewire-pulse
	wireplumber

  	# Network Config
  	networkmanager
  	network-manager-applet
)
aur_packages=(
	yay-bin
)

prepare() {
	# We need the ostree hook.
	install -d "$rootfs/etc"
	install -m 0644 mkinitcpio.conf "$rootfs/etc/"
}

# This is needed to be able to install AUR packages.
post_install_early() {
	echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' > /etc/pacman.d/mirrorlist
	pacman-key --init
	pacman-key --populate
}

post_install() {
	mkdir -p /boot/efi

  	cp scripts/create-user.sh /usr/local/bin/create-user.sh
   	chmod +x /usr/local/bin/create-user.sh
    	cp services/create-user.service /etc/systemd/system/create-user.service
    
	# Timezone
	ln -sf /usr/share/zoneinfo/Canada/Mountain /etc/localtime

	# Locale
	sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
	locale-gen

	# Enable services
 	systemctl enable create-user.service
	systemctl enable systemd-timesyncd.service
  	systemctl enable NetworkManager.service
	systemctl enable systemd-resolved.service
  	systemctl enable sddm.service
}

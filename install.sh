#!/bin/bash

# System update

echo "System update"
sudo pacman -Syu --noconfirm
echo "System have been updated"

#TRIM
echo "Enable TRIM"
sudo systemctl enable fstrim.timer

# Add guest user

echo "Creating guest user without password..."
sudo useradd -m -G wheel -s /bin/bash guest
echo "guest:" | sudo chpasswd
echo "Allowing password-less sudo for guest user..."
echo "guest ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/guest
sudo chmod 440 /etc/sudoers.d/guest

# Soft install
# Git & base-devel
sudo pacman -S --noconfirm git --needed base-devel
# HYPR
sudo pacman -S --noconfirm hyprlock hyprpaper hyprshot waybar
# Fonts
sudo pacman -S --noconfirm ttf-font-awesome otf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-liberation ttf-jetbarains-mono
# Bluetooth
sudo pacman -S --noconfirm bluez bluez-utils blueman
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
# Network
sudo pacman -S networkmanager network-manager-applet
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
# Programms
sudo pacman -S telegram-desktop discord steam intellij-idea-community-edition code nodejs npm
# YAY
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi
# YAY soft
yay -S google-chrome
# Copying configs
REPO_PATH="$PWD"
CONFIG_PATH="$HOME/.config"
echo "Copying configuration files..."
mkdir -p "$CONFIG_PATH/hypr"
mkdir -p "$CONFIG_PATH/kitty"
mkdir -p "$CONFIG_PATH/waybar"
mkdir -p "$CONFIG_PATH/wlogout"
mkdir -p "$CONFIG_PATH/wofi"
cp -r "$REPO_PATH/hypr"/* "$CONFIG_PATH/hypr/"
cp -r "$REPO_PATH/kitty"/* "$CONFIG_PATH/kitty/"
cp -r "$REPO_PATH/waybar"/* "$CONFIG_PATH/waybar/"
cp -r "$REPO_PATH/wlogout"/* "$CONFIG_PATH/wlogout/"
cp -r "$REPO_PATH/wofi"/* "$CONFIG_PATH/wofi/"

# Wallpapers
echo "Copying wallpapers..."
Wallpapers_Path="$HOME/Pictures/Wallpapers/"
mkdir -p "$Wallpapers_Path"
cp -r "$REPO_PATH/Wallpapers"/* "$Wallpapers_Path"

# Reboot system
sudo reboot
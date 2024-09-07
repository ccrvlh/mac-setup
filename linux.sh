#!/bin/bash

# Function for pretty outputs
pretty_print() {
  echo "============================================================"
  echo "$1"
  echo "============================================================"
}

# Update system
pretty_print "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install necessary packages
pretty_print "Installing necessary packages..."
sudo apt install -y git curl wget build-essential zsh gnome-tweaks dconf-cli gnome-shell-extensions

# Set dark theme
pretty_print "Setting up dark theme..."
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru"

# Configure the dock to float at the bottom, with icon size 30
pretty_print "Configuring the dock..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 30
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

# Install and setup Zsh
pretty_print "Installing Zsh..."
sudo apt install -y zsh

pretty_print "Setting Zsh as the default shell..."
chsh -s $(which zsh)

# Install Oh My Zsh
pretty_print "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Restart Gnome shell (to apply appearance settings)
pretty_print "Restarting Gnome shell..."
killall -3 gnome-shell

pretty_print "Done! Please restart your system for all changes to take effect."

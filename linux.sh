#!/bin/bash

# Function for pretty outputs
pretty_print() {
  echo "============================================================"
  echo "$1"
  echo "============================================================"
}

packages = (
  "git",
  "curl",
  "wget",
  "build-essential",
  "zsh",
  "gnome-tweaks",
  "dconf-cli",
  "gnome-shell-extensions",
  "flatpak",
  "gnome-software-plugin-flatpak",
  "zsh"
)

apps = (
  "it.faviodistasio.AntaresSQL",
  "com.google.Chrome",
  "org.mozilla.firefox",
  "com.brave.Browser",
  "org.videolan.VLC",
  "org.videolan.VLC",
  "com.spotify.Client",
  "md.obsidian.Obsidian",
  "org.onlyoffice.desktopeditors",
  "com.visualstudio.code",
  "io.github.zen_browser.zen",
  "com.protonvpn.www",
  "com.bitwarden.desktop",
  "org.signal.Signal",
  "org.blender.Blender",
  "com.getpostman.Postman",
  "com.slack.Slack",
  "com.transmissionbt.Transmission",
  "org.gnome.Maps",
  "dev.zed.Zed",
  "me.proton.Mail",
  "com.google.EarthPro",
  "com.dropbox.Client",
  "com.getmailspring.Mailspring",
  "com.discordapp.Discord",
  "io.httpie.Httpie",
  "io.podman_desktop.PodmanDesktop",
)

# Update system
updateSystem() {
  pretty_print "Updating system packages..."
  sudo apt update && sudo apt upgrade -y
}

installPackages() {
  # Install necessary packages
  pretty_print "Installing necessary packages..."
  sudo apt install -y 
}

configureShell() {
  pretty_print "Setting Zsh as the default shell..."
  chsh -s $(which zsh)
  
  pretty_print "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  
  pretty_print "Restarting Gnome shell..."
  killall -3 gnome-shell
}

# Set dark theme
configureAppearance() {
  pretty_print "Setting up dark theme..."
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
  gsettings set org.gnome.desktop.interface icon-theme "Yaru"
}


# Configure the dock to float at the bottom, with icon size 30
configureDock() {
  pretty_print "Configuring the dock..."
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
  gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
  gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
  gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 30
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
}

installFlatpak() {
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

installApp() {
  flatpak install flathub $1
}

pinToDock() {
  gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), $1)"
}


pretty_print "Done! Please restart your system for all changes to take effect."



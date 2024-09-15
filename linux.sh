#!/bin/bash

# Function for pretty outputs
pretty_print() {
  echo "============================================================"
  echo "$1"
  echo "============================================================"
}

# Define a function to handle errors
handle_error() {
    echo "An error occurred in the script at line: $1"
    exit 1
}


# Set a trap to call the error handling function
trap 'handle_error $LINENO' ERR



packages = (
  git
  curl
  wget
  build-essential
  redis
  jq
  zsh
  gnome-tweaks
  dconf-cli
  gnome-shell-extensions
  flatpak
  gnome-software-plugin-flatpak
  zsh
)

apps = (
  it.faviodistasio.AntaresSQL
  com.google.Chrome
  org.mozilla.firefox
  com.brave.Browser
  org.videolan.VLC
  org.videolan.VLC
  com.spotify.Client
  md.obsidian.Obsidian
  org.onlyoffice.desktopeditors
  com.visualstudio.code
  io.github.zen_browser.zen
  com.protonvpn.www
  com.bitwarden.desktop
  org.signal.Signal
  org.blender.Blender
  com.getpostman.Postman
  com.slack.Slack
  com.transmissionbt.Transmission
  org.gnome.Maps
  dev.zed.Zed
  me.proton.Mail
  com.google.EarthPro
  com.dropbox.Client
  com.getmailspring.Mailspring
  com.discordapp.Discord
  io.httpie.Httpie
  io.podman_desktop.PodmanDesktop
)

vscodeExtensions=(
    bradlc.vscode-tailwindcss
    dracula-theme.theme-dracula
    dsznajder.es7-react-js-snippets
    eamodio.gitlens
    esbenp.prettier-vscode
    GitHub.copilot
    GitHub.copilot-chat
    GitHub.remotehub
    golang.go
    matangover.mypy
    ms-azuretools.vscode-docker
    ms-python.black-formatter
    ms-python.isort
    ms-python.python
    ms-python.vscode-pylance
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode-remote.vscode-remote-extensionpack
    ms-vscode.remote-explorer
    ms-vscode.remote-repositories
    ms-vscode.remote-server
    njpwerner.autodocstring
    PKief.material-icon-theme
    tamasfe.even-better-toml
    VisualStudioExptTeam.intellicode-api-usage-examples
    VisualStudioExptTeam.vscodeintellicode
)


# Prompts

echo "Enter your name:"
read username

echo "Enter your email:"
read email

echo "You entered:"
echo "Name: $username"
echo "Email: $email"

# Ask for confirmation
read -p "Is this correct? (y/n) " choice
case "$choice" in 
  y|Y ) 
    # Proceed with the variable
    echo "Hello, $username! Let's start the setup."
    ;;
  n|N ) 
    echo "Please re-run the script and provide the correct input."
    ;;
  * ) 
    echo "Invalid choice. Please enter 'y' for yes or 'n' for no."
    ;;
esac


# Update system
updateSystem(){
  pretty_print "Updating system packages..."
  sudo apt update && sudo apt upgrade -y
}


configureShell(){
  pretty_print "Setting Zsh as the default shell..."
  chsh -s $(which zsh)
  
  pretty_print "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  
  pretty_print "Restarting Gnome shell..."
  killall -3 gnome-shell
}

# Set dark theme
configureAppearance(){
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

installPackages(){
    echo "Installing packages..."
    for i in "${packages[@]}"
    do
        if brew list --formula | grep -q "^$i\$"; then
            echo "$i is already installed. Skipping..."
        else
            echo -n -e "Installing ${GREEN}$i${NC}..."
            if brew install $i; then
                echo -e "\rInstalling ${GREEN}$i${NC}... ${GREEN}Done.${NC}"
            else
                echo -e "\rInstalling ${GREEN}$i${NC}... ${RED}Failed.${NC}"
            fi
        fi
    done
}

configureGit(){
    echo "Git config"
    git config --global user.name $username
    git config --global user.email $email
}


## Python & Node

installPython(){
    # Pyenv
    brew install pyenv

    # Pyenv Verions
    pyenv install 3.7.8;
    pyenv install 3.8.10;
    pyenv install 3.9.5;
    pyenv install 3.10.6;
    pyenv install 3.11.6;

    # Setup global version
    pyenv global 3.11.6;
}

installPoetry(){
    # Install Poetry
    curl -sSL https://install.python-poetry.org | python3 -

    # Add Poetry to PATH
    echo '$HOME/.local/bin' >> ~/.zshrc

    # Generate the config file
    poetry completions zsh > ~/.zfunc/_poetry
    poetry config

    # Fill the file
    echo '[virtualenvs]' >> ~/Library/Application\ Support/pypoetry/config.toml
    echo 'in-project=true' >> ~/Library/Application\ Support/pypoetry/config.toml
    echo 'prompt=".venv"' >> ~/Library/Application\ Support/pypoetry/config.toml
}

setupPyenvConfig() {
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
}

installNodeUtils(){
    # Clean Old versions
    brew uninstall --ignore-dependencies node 
    brew uninstall --force node
    brew install nvm
    brew install yarn
    mkdir ~/.nvm

    # Add NVM to bash_profile
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && \. "/usr/local/opt/nvm/etc/bash_completion"
}

installPostgres(){
    echo "Installing Postgres..."
    brew install postgres@14
    brew services start postgres;
    createuser -s postgres;
    echo "Installing Postgres... done."
}

installGolang(){
    echo "Installing Go..."
    brew install go
    echo "Installing Go... done."
}


configureZSH(){
# Set theme
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="gentoo"/' ~/.zshrc
cat << EOF >> ~/.zshrc

##############
# User Config

# Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ZSH Highlight
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[arg0]='fg=yellow,bold'

# Alias
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"

# Pyenv
export PATH="\$HOME/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"

# Golang
export PATH="\$PATH:\$(go env GOPATH)/bin"

# NVM
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# VSCode
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

EOF
}

configureVSCode(){
    echo "Installing VSCode Extensions..."
    for i in "${vscodeExtensions[@]}"
    do
        echo -n -e "Installing Extension ${GREEN}$i${NC}..."
        if code --install-extension "$i"; then
            echo -e "\rInstalling Extension ${GREEN}$i${NC}... ${GREEN}Done.${NC}"
        else
            echo -e "\rInstalling Extension ${GREEN}$i${NC}... ${RED}Failed.${NC}"
        fi
    done
}


installFlatpak(){
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

installApp(){
  flatpak install flathub $1
}

pinToDock(){
  gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), $1)"
}

setupSSH(){
    echo "Setting up SSH keys..."
    mkdir ~/.ssh
    touch ~/.ssh/config
    ssh-keygen -t rsa -b 4096 -C $email
    ssh-add -K ~/.ssh/id_rsa;
}

pretty_print "Done! Please restart your system for all changes to take effect."



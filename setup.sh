#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


packages=(
    git
    make
    redis
    tree
    htop-osx
    xz
    zlib
    jq
    git-flow-avh
    openssl
    zsh-autosuggestions
    zsh-syntax-highlighting
    readline
    mas
)

apps=(
    balenaetcher
    discord
    docker
    dropbox
    figma
    iterm2
    notion
    numi
    postico
    postman
    slack
    spotify
    stats
    the-unarchiver
    visual-studio-code
    transmission
    whatsapp
    geekbench
    raycast
    obsidian
    virtualbox
    zoomus
    firefox
    brave-browser
    microsoft-edge
    google-chrome
    rectangle
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


## Utils

# Define a function to handle errors
handle_error() {
    echo "An error occurred in the script at line: $1"
    exit 1
}

# Set a trap to call the error handling function
trap 'handle_error $LINENO' ERR


## System Setup

setupSystemSettings(){
    # Show Library folder
    chflags nohidden ~/Library;

    # Show hidden files
    defaults write com.apple.finder AppleShowAllFiles YES;

    # Allow text selection in Quick Look
    defaults write com.apple.finder QLEnableTextSelection -bool TRUE

    # Showing icons for hard drives, servers, and removable media on the desktop
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

    # Disabling the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Avoiding the creation of .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Setting screenshots location to ~/Desktop
    defaults write com.apple.screencapture location -string "$HOME/Desktop"

    # Setting screenshot format to PNG
    defaults write com.apple.screencapture type -string "png"

    # Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    
    # Disable 'natural' (Lion-style) scrolling
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
}

setupSystemSettingsAdvanced(){

    # Set keyboard settings
    defaults write -g com.apple.keyboard.fnState 1
    defaults write -g InitialKeyRepeat = 25;
    defaults write -g KeyRepeat = 2;
    defaults write -g KeyRepeatDelay = "0.416666666";
    defaults write -g KeyRepeatEnabled = 1;

    #"Disable the sudden motion sensor as its not useful for SSDs"
    sudo pmset -a sms 0

    #"Speeding up wake from sleep to 24 hours from an hour"
    # http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
    sudo pmset -a standbydelay 86400


    #"Enabling snap-to-grid for icons on the desktop and in other icon views"
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

    #"Disabling system-wide resume"
    defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

    #"Disabling automatic termination of inactive apps"
    defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
    
    #"Expanding the save panel by default"
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

    #"Saving to disk (not to iCloud) by default"
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

    #"Disable smart quotes and smart dashes as they are annoying when typing code"
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false


    #"Disabling press-and-hold for keys in favor of a key repeat"
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    #"Enabling subpixel font rendering on non-Apple LCDs"
    defaults write NSGlobalDomain AppleFontSmoothing -int 2


    #"Showing all filename extensions in Finder by default"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    #"Adding a context menu item for showing the Web Inspector in web views"
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
}

setupDock(){
    # Don’t automatically rearrange Spaces based on most recent use
    defaults write com.apple.dock mru-spaces -bool false
    
    #"Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
    defaults write com.apple.dock tilesize -int 36

    #"Speeding up Mission Control animations and grouping windows by application"
    defaults write com.apple.dock expose-animation-duration -float 0.1
    defaults write com.apple.dock "expose-group-by-app" -bool true

    #"Setting Dock to auto-hide and removing the auto-hiding delay"
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0
}

setupSSH(){
    echo "Setting up SSH keys..."
    mkdir ~/.ssh
    touch ~/.ssh/config
    ssh-keygen -t rsa -b 4096 -C $email
    ssh-add -K ~/.ssh/id_rsa;
}

## App Installations

installXCode(){
    echo "Installing xcode-stuff"
    xcode-select --install
}

installHomebrew(){
    # Check for Homebrew, install if we don't have it
    if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Updating homebrew..."
    brew update
}

installBrewPackages(){
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
    brew cleanup
}

installApplications(){
    echo "installing apps with Cask..."
    for i in "${apps[@]}"
    do
        if brew list --cask | grep -q "^$i\$"; then
            echo "$i is already installed. Skipping..."
        else
            echo -e "Installing ${GREEN}$i${NC}..."
            brew cask install ${$i} 
            echo -e "Installing ${GREEN}$i${NC}... Done."
        fi
    done
    # Remove outdated versions from the cellar.
    brew cask cleanup
    brew cleanup
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

# Configure Shell

installOMZ(){
    echo "Installing Oh My ZSH..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

configureGit(){
    echo "Git config"
    git config --global user.name $username
    git config --global user.email $email
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

runAll() {
    echo "Starting setup..."
    mkdir ~/.init
    
    echo "Configuring System..."
    if result=$(setupSSH); then
        touch ~/.init/success_ssh_function
        echo -e "${GREEN}[SUCCESS]${NC} SSH configured successfully."
    else
        touch ~/.init/error_ssh_function
        echo -e "${RED}[ERROR]${NC} Error occurred when configuring SSH."
    fi

    if result=$(setupSystemSettings); then
        touch ~/.init/success_system_settings_function
        echo -e "${GREEN}[SUCCESS]${NC} System settings configured successfully."
    else
        touch ~/.init/error_system_settings_function
        echo -e "${RED}[ERROR]${NC} Error occurred when configuring system settings."
    fi

    
    echo "Installing Apps..."
    if result=$(installXCode); then
        touch ~/.init/success_xcode_function
        echo -e "${GREEN}[SUCCESS]${NC} XCode Installed successfully."
    else
        touch ~/.init/error_xcode_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing XCode."
    fi
    
    if result=$(installHomebrew); then
        touch ~/.init/success_brew_function
        echo -e "${GREEN}[SUCCESS]${NC} Homebrew Installed successfully."
    else
        touch ~/.init/error_brew_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Homebrew."
    fi
    
    if result=$(installBrewPackages); then
        touch ~/.init/success_brew_packages_function
        echo -e "${GREEN}[SUCCESS]${NC} Homebrew Packages Installed successfully."
    else
        touch ~/.init/error_brew_packages_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Homebrew Packages."
    fi
    
    if result=$(installApplications); then
        touch ~/.init/success_brew_apps_function
        echo -e "${GREEN}[SUCCESS]${NC} Homebrew Applications Installed successfully."
    else
        touch ~/.init/error_brew_apps_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Homebrew Applications."
    fi

    echo "Setting up Developer Environment..."
    if result=$(installPython); then
        touch ~/.init/success_python_function
        echo -e "${GREEN}[SUCCESS]${NC} Python installed successfully."
    else
        touch ~/.init/error_python_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Python."
    fi

    if result=$(installPoetry); then
        touch ~/.init/success_poetry_function
        echo -e "${GREEN}[SUCCESS]${NC} Poetry installed successfully."
    else
        touch ~/.init/error_poetry_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Poetry."
    fi

    if result=$(installNodeUtils); then
        touch ~/.init/success_node_function
        echo -e "${GREEN}[SUCCESS]${NC} Node utilities installed successfully."
    else
        touch ~/.init/error_node_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Node utilities."
    fi

    if result=$(installPostgres); then
        touch ~/.init/success_postgres_function
        echo -e "${GREEN}[SUCCESS]${NC} Postgres installed successfully."
    else
        touch ~/.init/error_postgres_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Postgres."
    fi

    if result=$(installGolang); then
        touch ~/.init/success_golang_function
        echo -e "${GREEN}[SUCCESS]${NC} Golang installed successfully."
    else
        touch ~/.init/error_golang_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Golang."
    fi

    if result=$(installOMZ); then
        touch ~/.init/success_omz_function
        echo -e "${GREEN}[SUCCESS]${NC} Oh My Zsh installed successfully."
    else
        touch ~/.init/error_omz_function
        echo -e "${RED}[ERROR]${NC} Error occurred when installing Oh My Zsh."
    fi


    echo "Configuring Shell..."    
    if result=$(configureZSH); then
        touch ~/.init/success_zsh_config_function
        echo -e "${GREEN}[SUCCESS]${NC} Zsh configured successfully."
    else
        touch ~/.init/error_zsh_config_function
        echo -e "${RED}[ERROR]${NC} Error occurred when configuring Zsh."
    fi

    if result=$(configureVSCode); then
        touch ~/.init/success_vscode_ext_function
        echo -e "${GREEN}[SUCCESS]${NC} VSCode Extensions configured successfully."
    else
        touch ~/.init/error_vscode_ext_function
        echo -e "${RED}[ERROR]${NC} Error occurred when configuring VSCode Extensions."
    fi

    if result=$(configureGit); then
        touch ~/.init/success_git_config_function
        echo -e "${GREEN}[SUCCESS]${NC} Git configured successfully."
    else
        touch ~/.init/error_git_config_function
        echo -e "${RED}[ERROR]${NC} Error occurred when configuring Git."
    fi
    
    killall Finder
    echo "Done!"

    # setupSystemSettingsAdvanced
    # setupDock
    # setupTransmission
    # setupSafari
}

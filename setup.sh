#!/bin/bash
function header {
    echo "$(tput setaf 3)$1$(tput setaf 7)"
    horizontal_line
}

function horizontal_line {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

function run_cmd {
    #Print command description
    echo -n $1
    cmd_output=`$2 2>&1`
    if [ $? -eq 0 ]; then
        #Print OK in green text
        echo "$(tput setaf 2) [ OK ] $(tput setaf 7)"
    else
        #Print FAIL in red text
        echo "$(tput setaf 1) [ FAIL ] $(tput setaf 7)"
        echo "cmd:" $2 "output:" $cmd_output
    fi
}

function check_sudo {
    if [[ "$EUID" = 0 ]]; then
        echo "Already root..."
    else
        sudo -k # make sure to ask for password on next sudo
        if sudo false; then
            echo "Need to become root..."
            exit 1
        fi
    fi
}

header "STEP 1: BREW PACKAGE MANAGER" #Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

run_cmd ">> Setting .zprofile..."           "echo \"eval \"$(/opt/homebrew/bin/brew shellenv)\"\" >> /Users/lyndros/.zprofile"
run_cmd ">> Setting current environment..." 'eval $(/opt/homebrew/bin/brew shellenv)'

BREW_PREFIX=$(brew --prefix) # Save Homebrew’s installed location
run_cmd ">> Updating..."              "${BREW_PREFIX}/bin/brew update" 
run_cmd ">> Upgrading..."             "${BREW_PREFIX}/bin/brew upgrade"

header "STEP 2: BREW TOOLS" #Install brew tools
run_cmd ">> Installing moreutils..."  "${BREW_PREFIX}/bin/brew install moreutils"   # Install some other useful utilities like `sponge`
run_cmd ">> Installing findutils..."  "${BREW_PREFIX}/bin/brew install findutils"   # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
run_cmd ">> Installing gnu-sed..."    "${BREW_PREFIX}/bin/brew install gnu-sed"     # Install GNU `sed`
run_cmd ">> Installing wget..."       "${BREW_PREFIX}/bin/brew install wget"
run_cmd ">> Installing htop..."       "${BREW_PREFIX}/bin/brew install htop"
run_cmd ">> Installing gnupg..."      "${BREW_PREFIX}/bin/brew install gnupg"
run_cmd ">> Installing tmux..."       "${BREW_PREFIX}/bin/brew install tmux"
run_cmd ">> Installing k8s cli..."    "${BREW_PREFIX}/bin/brew install kubernetes-cli"
run_cmd ">> Installing jq..."         "${BREW_PREFIX}/bin/brew install jq"
run_cmd ">> Installing ripgrep..."    "${BREW_PREFIX}/bin/brew install ripgrep"
run_cmd ">> Installing fd..."         "${BREW_PREFIX}/bin/brew install fd"
run_cmd ">> Installing fzf..."        "${BREW_PREFIX}/bin/brew install fzf"
run_cmd ">> Installing neovim..."     "${BREW_PREFIX}/bin/brew install neovim"
run_cmd ">> Installing node..."       "${BREW_PREFIX}/bin/brew install node"
run_cmd ">> Installing typescript..." "${BREW_PREFIX}/bin/npm install -g typescript"

header "STEP 3: SDKMAN" #Install sdkman
curl -s "https://get.sdkman.io" | bash

header "STEP 4: Deleting previous environment files"
run_cmd ">> Deleting .zshrc..."         "rm -rf $HOME/.zshrc"
run_cmd ">> Deleting .zprofile..."      "rm -rf $HOME/.zprofile"
run_cmd ">> Deleting .bash_profile..."  "rm -rf $HOME/.bash_profile"
run_cmd ">> Deleting .aliases..."       "rm -rf $HOME/.aliases"
run_cmd ">> Deleting .exports..."       "rm -rf $HOME/.exports"
run_cmd ">> Deleting .p10k.zsh..."      "rm -rf $HOME/.p10k.zsh"
run_cmd ">> Deleting .cht-languages..." "rm -rf $HOME/.cht-languages"
run_cmd ">> Deleting .cht-commands..."  "rm -rf $HOME/.cht-commands"
run_cmd ">> Deleting .gitconfig..."     "rm -rf $HOME/.gitconfig"
run_cmd ">> Deleting .gitignore..."     "rm -rf $HOME/.gitignore"
run_cmd ">> Deleting .hushlogin..."     "rm -rf $HOME/.hushlogin"
run_cmd ">> Deleting .screenrc..."      "rm -rf $HOME/.screenrc"
run_cmd ">> Deleting .tmux.conf..."     "rm -rf $HOME/.tmux.conf"
run_cmd ">> Deleting .vimrc..."         "rm -rf $HOME/.vimrc"
run_cmd ">> Deleting folder .vim..."     "rm -rf $HOME/.vim"
run_cmd ">> Deleting folder .scripts..." "rm -rf $HOME/.scripts"
run_cmd ">> Deleting folder .config..."  "rm -rf $HOME/.config"

header "STEP 5: Installing new folders"
PWD=`pwd`
run_cmd ">> Setting cht folder..."              "cp -R $PWD/.scripts $HOME"
run_cmd ">> Setting up vim folder..."           "cp -R $PWD/.vim $HOME"
run_cmd ">> Setting up nvim folder..."          "cp -R $PWD/.config $HOME"
run_cmd ">> Setting up personal dotfiles..."    "cp -R $PWD/.dotfiles-personal $HOME"
run_cmd ">> Setting up work dotfiles..."        "cp -R $PWD/.dotfiles-work $HOME"


header "STEP 6: Installing iTerm, ZSH eyecandy and tools"
run_cmd ">> Installing iTerm2..."               "brew install iterm2"
run_cmd ">> Installing Oh My ZSH..."            "brew install zsh"
run_cmd ">> Installing ZSH antigen..."          "brew install antigen"
run_cmd ">> Installing zsh-hightlighting..."    "brew install zsh-syntax-highlighting"
run_cmd ">> Installing zsh-autosuggestions..."  "brew install zsh-autosuggestions"
run_cmd ">> Installing powerlevel10k fonts..."  "brew install romkatv/powerlevel10k/powerlevel10k"
run_cmd ">> Installing ddgr..."                 "brew install ddgr"
run_cmd ">> Installing vim plug..."             "curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
run_cmd ">> Installing neovim-remote..."        "pip3 install --user --upgrade neovim-remote"

header "STEP 7: Installing ansible"
run_cmd ">> Installing ansible..."              "brew install ansible"
run_cmd ">> Installing ansible-lint..."         "brew install ansible-lint"

header "STEP 8: Installing new dotfiles"
run_cmd ">> Setting up .zshrc..."        "ln -s $PWD/.zshrc $HOME/.zshrc"
run_cmd ">> Setting up .zprofile..."     "ln -s $PWD/.zprofile $HOME/.zprofile"
run_cmd ">> Setting up .bash_profile..." "ln -s $PWD/.bash_profile $HOME/.bash_profile"
run_cmd ">> Setting up .aliases..."      "ln -s $PWD/.aliases $HOME/.aliases"
run_cmd ">> Setting up .exports..."      "ln -s $PWD/.exports $HOME/.exports"
run_cmd ">> Setting up .bash_profile..." "ln -s $PWD/.p10k.zsh $HOME/.p10k.zsh"
run_cmd ">> Setting up .cht-languages.." "ln -s $PWD/.cht-languages $HOME/.cht-languages"
run_cmd ">> Setting up .cht-commands..." "ln -s $PWD/.cht-commands $HOME/.cht-commands"
run_cmd ">> Setting up .gitconfig..."    "ln -s $PWD/.gitconfig $HOME/.gitconfig"
run_cmd ">> Setting up .gitignore..."    "ln -s $PWD/.gitignore $HOME/.gitignore"
run_cmd ">> Setting up .hushlogin..."    "ln -s $PWD/.hushlogin $HOME/.hushlogin"
run_cmd ">> Setting up .screenrc..."     "ln -s $PWD/.screenrc $HOME/.screenrc"
run_cmd ">> Setting up .tmux.conf..."    "ln -s $PWD/.tmux.conf $HOME/.tmux.conf"
run_cmd ">> Setting up .vimrc..."        "ln -s $HOME/.config/nvim/init.vim $HOME/.vimrc"
run_cmd ">> Setting up .vim/autoload..." "ln -s $HOME/.vim/autoload $HOME/.config/nvim/"
run_cmd ">> Setting up .wrk-spaces..."   "cp $PWD/.wrk-spaces $HOME/.wrk-spaces"
run_cmd ">> Setting up .fav-spaces..."   "cp $PWD/.fav-spaces $HOME/.fav-spaces"

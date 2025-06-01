# This is where external apps config (pyenv, nvm, sdkman) should be configured

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Python version manager
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Cargo
. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/home/ren/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Android SDK
export ANDROID_SDK_ROOT='/opt/android-sdk'
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/
export PATH=$PATH:$ANDROID_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/
export PATH=$PATH:~/Android/Sdk/platform-tools

# opam
[[ ! -r /home/ren/.opam/opam-init/init.zsh ]] || source /home/ren/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# Sdkman (Java)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Golang
export PATH=$PATH:~/go/bin

# Ghcup
[ -f "/home/ren/.ghcup/env" ] && . "/home/ren/.ghcup/env" # ghcup-env

# Dotnet
export PATH="$PATH:/home/ren/.dotnet/tools"
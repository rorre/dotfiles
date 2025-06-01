setopt hist_ignore_all_dups
setopt hist_ignore_space

export PATH="$HOME/.local/bin:$PATH"
export BROWSER=zen-browser
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
export HISTSIZE=999999999
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=$HISTSIZE
export JAVA_HOME='/usr/lib/jvm/default-runtime'
export PATH=/opt/depot_tools:$PATH
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
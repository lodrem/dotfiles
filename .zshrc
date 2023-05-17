# source iff file exists
include() {
  [[ -f "$1" ]] && source "$1"
}

setup_antigen() {
  source $HOME/antigen.zsh
  antigen use oh-my-zsh
  antigen theme simple

  # Setup plugins
  plugins=(
    git z rust kubectl
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
  )
  for plugin in ${plugins[@]}; do
    antigen bundle ${plugin}
  done

  if type brew &>/dev/null
  then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
  fi

  antigen apply
}

setup_fzf() {
  # fzf for mac
  include ~/.fzf.zsh

  # fzf for archlinux
  include /usr/share/fzf/key-bindings.zsh
  include /usr/share/fzf/completion.zsh
}

setup_alias() {
  alias ls="lsd"
  alias tree="lsd --tree"
  alias vim="nvim"
  alias k="kubectl"
  alias py="python"

  bindkey \^U backward-kill-line
}

setup_antigen
setup_fzf
setup_alias

# ===============
# Custom commands
# ===============

# Rebase helper
rebase() {
  TARGET=${1:-master}
  CUR=$(git branch --show-current)
  REMOTES=$(git remote)
  UPSTREAM="upstream"
  if (($REMOTES[(I)$UPSTREAM])); then
    git fetch upstream master
    TARGET=upstream/master
  else
    git fetch origin master
    TARGET=origin/master
  fi
  echo "Rebasing ${CUR} on ${TARGET}"
  git checkout ${CUR}
  git rebase -i ${TARGET}
}

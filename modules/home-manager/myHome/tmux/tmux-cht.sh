#!/usr/bin/env bash

languages=(
  "golang"
  "solidity"
  "vlang"
  "v"
  "nodejs"
  "javascript"
  "tmux"
  "typescript"
  "zsh"
  "cpp"
  "c"
  "lua"
  "rust"
  "python"
  "bash"
  "php"
  "haskell"
  "ArnoldC"
  "css"
  "html"
  "gdb"
)

commands=(
  "find"
  "man"
  "tldr"
  "sed"
  "awk"
  "tr"
  "cp"
  "ls"
  "grep"
  "xargs"
  "rg"
  "ps"
  "mv"
  "kill"
  "lsof"
  "less"
  "head"
  "tail"
  "tar"
  "cp"
  "rm"
  "rename"
  "jq"
  "cat"
  "ssh"
  "cargo"
  "git"
  "git-worktree"
  "git-status"
  "git-commit"
  "git-rebase"
  "docker"
  "docker-compose"
  "stow"
  "chmod"
  "chown"
  "make"
)

combined=$(printf "%s\n" "${languages[@]}" "${commands[@]}")

selected=$(echo "$combined" | ~/.nix-profile/bin/fzf)

if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

found=false
for item in "${languages[@]}"; do
  if [[ "$item" == "$selected" ]]; then
    found=true
    break
  fi
done


if $found; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi


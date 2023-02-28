# Nix config using Home Manager

## Preparation

### Non-NixOS (e.g. Ubuntu)

Install nix

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
export NIX_CONFIG="experimental-features = nix-command flakes"
```

Install home manager

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## Switching

```sh
home-manager switch --flake ".#ben"
```

## TODO

* Default shell when SSHing is bash. Need to set to zsh
* GUI apps (alacritty, i3, etc)

# My NixOS configuration

## NixOS

### Installation (assuming host config already exists)

```bash
# All as root
HOST=...  # set host variable to use proper configuration

nix-shell
git clone https://this.repo.url/ /etc/nixos
cd /etc/nixos
nixos-install --root /mnt --impure --flake .#$HOST

# Reboot
```

### System update

```bash
# Go to the repo directory
nixos-rebuild switch --flake .
```

## Non-NixOS

Example steps necessary to bootstrap and use this configuration on Ubuntu.

### Installation

First make sure, your user is in the sudo/wheel group.

```bash
# Install git, curl and xz (e.g. for ubuntu)
sudo apt install git xz-utils curl

# Clone this repository
git clone https://gitlab.com/LongerHV/nixos-configuration.git
cd nixos-configuration

# Install nix (single-user installation)
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Activate nix profile (and add it to the .profile)
. ~/.nix-profile/etc/profile.d/nix.sh
echo ". $HOME/.nix-profile/etc/profile.d/nix.sh" >> ~/.profile
echo ". $HOME/.nix-profile/etc/profile.d/nix.sh" >> ~/.zprofile

# Open tempoary shell with nix and home-manager
nix-shell

# Remove nix (this is necessary, so home-manager can install nix)
nix-env -e nix

# Install the configuration
home-manager switch --flake .#ben

# Exit temporary shell
exit

# Set zsh (installed by nix) as default shell
echo ~/.nix-profile/bin/zsh | sudo tee -a /etc/shells
usermod -s ~/.nix-profile/bin/zsh $USER
```

### Update

```bash
# Go to the repo directory
home-manager switch --flake .
```

## Other Usage

### Dev Shells

Example:

```bash
nix develop .#lint
```

## Resources

- [LongerHV](https://github.com/LongerHV/nixos-configuration)

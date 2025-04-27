# default recipe to display help information
default:
  @just --list

# Update the flake
update:
  nix flake update

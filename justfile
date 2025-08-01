# default recipe to display help information
default:
  @just --list

# Rebuild the system
rebuild:
  nh os switch .

# Update the flake
update:
  nix flake update

# Update then rebuild
update-rebuild: update rebuild

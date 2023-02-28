{ pkgs, ... }:
pkgs.mkShell {
  shell = pkgs.zsh;
}

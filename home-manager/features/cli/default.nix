{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./fish
    ./git.nix
    ./starship.nix
  ];
  home.packages = with pkgs; [
    bc # calulator
    bottom # system viewer
    cht-sh # cheat.sh
    exa # better ls
    htop # better top
    httpie # better curl
    fd # better find
    fzf # fuzzy finder
    jq # JSON parsing
    lazydocker # docker tui
    lazygit # git tui
    neofetch # system info
    ncdu # disk usage tui
    ranger # file manager
    ripgrep # better grep
  ];
}

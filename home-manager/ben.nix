{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./features/cli
    ./features/browser/firefox.nix
    ./features/productivity
    ./features/tmux
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "ben";
    homeDirectory = "/home/ben";
  };

  home.packages = with pkgs; [
    any-nix-shell
    firefox
    netcat
    wget
    neovim
    go
    docker-compose
    nixfmt
    act
    colordiff
    spotify-tui
    openssh
    yj
    yq
    direnv
    cmake # needed for telescope-fzf-native.nvim
    gcc # for nvim parsers
    unzip # for nvim
    lldb # for nvim (DAP)
    kitty
    rofi
    polybar
    prusa-slicer
    lutris # battle.net
    path-of-building
    discord
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.file."./.config/nvim/" = {
    source = ./features/nvim;
    recursive = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

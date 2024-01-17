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
      permittedInsecurePackages = pkgs.lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";
    };
  };

  home = {
    username = "ben";
    homeDirectory = "/home/ben";
  };

  home.packages = with pkgs; [
    act
    any-nix-shell        # fish support for nix shell
    arandr               # simple GUI for xrandr
    colordiff
    direnv
    discord
    docker-compose
    firefox
    go
    kitty
    lutris              # battle.net
    netcat
    ollama
    openssh
    path-of-building
    polybar
    prusa-slicer
    nixfmt
    rofi
    spotify-tui
    vscode
    wget
    yj
    yq
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.cli;
in {
  options.myHome.cli = {
    enable = (lib.mkEnableOption "cli") // {default = true;};
    personalGitEnable = (lib.mkEnableOption "personalGitEnable") // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gh.enable = true;
      zsh.shellAliases = {
        lg = "lazygit";
      };
      git = {
        enable = true;
        userName = lib.mkIf cfg.personalGitEnable "bjharding";
        userEmail = lib.mkIf cfg.personalGitEnable "benjamin.j.harding@gmail.com";
        extraConfig.checkout.defaultRemote = "origin";
      };
    };
    home.packages = with pkgs; [
      colordiff
      curl
      fd
      file
      fzf
      htop
      jq
      lazygit
      neofetch
      nix-tree
      openssh
      p7zip
      ranger
      ripgrep
      unzip
      wget
      xh
      yj
      yq
    ];
  };
}

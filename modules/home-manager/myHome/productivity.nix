{ pkgs, config, lib, ... }:

let
  cfg = config.myHome.productivity;
in
{
  options.myHome.productivity.enable = lib.mkEnableOption "productivity";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      todoist-electron
      obsidian
      libreoffice-qt
      anki
      nextcloud-client
    ];
  };
}

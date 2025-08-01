{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mySystem.gaming;
in {
  options.mySystem.gaming = {
    enable = lib.mkEnableOption "gaming";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [lutris path-of-building protonup-ng wine wowup-cf];
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      gamemode.enable = true;
      sunshine.enable = true;
      corectrl = {
        enable = true;
      };
    };
  };
}

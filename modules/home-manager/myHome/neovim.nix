{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.myHome.neovim;
in {
  options.myHome.neovim = {
    enable = mkEnableOption "Enable neovim with custom configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.neovim-config.packages.${pkgs.system}.default
    ];
  };
}

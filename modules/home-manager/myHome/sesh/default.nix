{ config, lib, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      sesh
    ];
    home.file.".config/sesh/sesh.toml".source = ./config/sesh.toml;
  };
}

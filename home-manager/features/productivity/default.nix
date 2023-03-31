{ pkgs, ... }: {
  imports = [
  ];
  home.packages = with pkgs; [
    obsidian
  ];

}

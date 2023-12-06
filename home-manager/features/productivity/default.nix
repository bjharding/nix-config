{ pkgs, ... }: {
  imports = [ ];
  home.packages = with pkgs; [ 
    # obsidian # issue with electron. need to figure out how to use unstable version
  ];

}

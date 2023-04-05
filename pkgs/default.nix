{ pkgs ? import <nixpkgs> { } }: {

  # Packages with an actual source
#  phpactor = pkgs.callPackage ./phpactor { };
#  rgbdaemon = pkgs.callPackage ./rgbdaemon { };
#  shellcolord = pkgs.callPackage ./shellcolord { };
#  trekscii = pkgs.callPackage ./trekscii { };
#  speedtestpp = pkgs.callPackage ./speedtestpp { };
#  lando = pkgs.callPackage ./lando { };
#  tidal-dl = pkgs.python3Packages.callPackage ./tidal-dl { };
  # TODO: remove when https://github.com/NixOS/nixpkgs/pull/210717 is merged
#  gh-markdown-preview = pkgs.callPackage ./gh-markdown-preview { };

  # Personal scripts
#  minicava = pkgs.callPackage ./minicava { };
#  pass-wofi = pkgs.callPackage ./pass-wofi { };
#  primary-xwayland = pkgs.callPackage ./primary-xwayland { };
#  wl-mirror-pick = pkgs.callPackage ./wl-mirror-pick { };
#  lyrics = pkgs.callPackage ./lyrics { };
#  xpo = pkgs.callPackage ./xpo { };

  # My slightly customized plymouth theme, just makes the blue outline white
#  plymouth-spinner-monochrome = pkgs.callPackage ./plymouth-spinner-monochrome { };
}

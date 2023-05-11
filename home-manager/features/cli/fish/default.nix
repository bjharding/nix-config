{ config, pkgs, lib, ... }:

let
  fzfConfig = ''
    set -x FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
    set -x SKIM_DEFAULT_COMMAND "rg --files || fd || find ."
  '';

  themeConfig = ''
    set -g theme_display_date no
    set -g theme_display_git_master_branch no
    set -g theme_nerd_fonts yes
    set -g theme_newline_cursor yes
    set -g theme_color_scheme solarized
  '';

  custom = pkgs.callPackage ./plugins.nix { };

  fishConfig = ''
    bind \t accept-autosuggestion
    set fish_greeting
  '' + fzfConfig + themeConfig;

in {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source

      fish_vi_key_bindings
      set fish_cursor_default block blink
      set fish_cursor_insert line blink
      set fish_cursor_replace_one underscore blink
      set fish_cursor_visual block
    '';
    shellAbbrs = {
        ls = "exa";
        ll = "exa -l";
        n = "nix";
        nd = "nix develop -c $SHELL";
        ns = "nix shell";
        nsn = "nix shell nixpkgs#";
        nb = "nix build";
        nbn = "nix build nixpkgs#";
        nf = "nix flake";

        nr = "nixos-rebuild --flake .";
        nrs = "nixos-rebuild --flake . switch";
        snr = "sudo nixos-rebuild --flake .";
        snrs = "sudo nixos-rebuild --flake . switch";
        hm = "home-manager --flake .";
        hms = "home-manager --flake . switch";
        v = "nvim";
        vi = "nvim";
        m = "neomutt";
        
      };
    shellAliases = {
      cat = "bat";
      du = "${pkgs.ncdu}/bin/ncdu --color dark -rr -x";
      ".." = "cd ..";
      ping = "${pkgs.prettyping}/bin/prettyping";
      tree = "${pkgs.exa}/bin/exa -T";
      getip = "http ifconfig.me";
      kssh = "kitt +kitten ssh";
      
    };
    shellInit = fishConfig;
  };
}

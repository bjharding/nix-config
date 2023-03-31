{ pkgs, ... }:
pkgs.mkShell {
  shell = pkgs.fish;
  buildInputs = with pkgs; [
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
  ];

  RUST_BACKTRACE = 1;
}

{pkgs, ...}:
pkgs.mkShellNoCC {
  nativeBuildInputs = with pkgs; [
    actionlint
    selene
    stylua
    statix
    alejandra
    yamllint
  ];
}

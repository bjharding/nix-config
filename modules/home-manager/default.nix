{
  default = {
    config,
    lib,
    ...
  }: {
    home = rec {
      username = lib.mkDefault "ben";
      homeDirectory = lib.mkDefault "/home/${username}";
      stateVersion = lib.mkDefault "24.05";
    };
  };
  myHome = import ./myHome;
}

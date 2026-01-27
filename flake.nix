{
  description = "lr2oraja-endlessdream flake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
      in
      {
        packages = {
          lr2oraja-endlessdream = pkgs.callPackage ./pkgs/lr2oraja-endlessdream/default.nix
            {
              libjportaudio = (pkgs.callPackage ./pkgs/libjportaudio/default.nix { });
            };
          default = self.packages.${system}.lr2oraja-endlessdream;

        };
      }
    );
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        callPackage = pkgs.lib.callPackageWith (pkgs // packages);
        packages = {
          libjportaudio = callPackage ./libjportaudio/default.nix { };
          lr2oraja-endlessdream = callPackage ./lr2oraja-endlessdream/default.nix { };
        };
      in
      packages
    );
}

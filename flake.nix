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
        packages = rec {
          lr2oraja-endlessdream = pkgs.callPackage ./pkgs/lr2oraja-endlessdream/default.nix
            {
              libjportaudio = (pkgs.callPackage ./pkgs/libjportaudio/default.nix { });
            };
          default = lr2oraja-endlessdream;
        };
        formatter = pkgs.nixpkgs-fmt;
        devShells = pkgs.mkShell
          {
            buildInputs = [ pkgs.hello pkgs.git ];
            shellHook = ''
              	echo "Entering a fresh development environment"
              			'';
          };
      }
    );
}

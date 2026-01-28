# How to install
To install this flake, you will need to add it as an input to your nix configuration flake like this: 
```nix
lr2oraja = {
  url = "github:PoshestPoro/lr2oraja-endlessdream-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

The easiest way to install it from here would be to inherit inputs into your home manager configuration and install it as a package like so:
```nix
inputs.lr2oraja.packages.${pkgs.system}.default
```

# Repositories used as references
```
https://git.fromouter.space/hamcha/beatoraja-nix/src/branch/master - Base for the flake
https://github.com/huantianad/nixos-config/tree/main - Base for the modules
```

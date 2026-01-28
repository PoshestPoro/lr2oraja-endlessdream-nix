# What is this
This is a nix flake that supplies an install for lr2oraja-endlessdream, which is a fork or lr2oraja, which is a fork of beatoraja. The original repository can be found here:
https://github.com/seraxis/lr2oraja-endlessdream

This comes preinstalled with a startup script, a desktop entry and bokutachi IR (https://boku.tachi.ac/). The icon for the desktop is found on the AUR pkgbuild for this project: https://aur.archlinux.org/packages/lr2oraja-endlessdream . 
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
# How to run
You should now be able to run it in the terminal with `lr2oraja-endlessdream` or you can run it through the desktop file. 
Make sure to swap your audio backend to port audio.
# Repositories used as references
```
https://git.fromouter.space/hamcha/beatoraja-nix/src/branch/master - Base for the flake
https://github.com/huantianad/nixos-config/tree/main - Base for the modules
```

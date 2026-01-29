# What is this
This is a nix flake that supplies an install for lr2oraja-endlessdream, which is a fork or lr2oraja, which is a fork of beatoraja. The original repository can be found here:
https://github.com/seraxis/lr2oraja-endlessdream

This comes preinstalled with a startup script, a desktop entry, bokutachi IR (https://boku.tachi.ac/) and libjportaudio. The icon for the desktop is found on the AUR pkgbuild for this project: https://aur.archlinux.org/packages/lr2oraja-endlessdream . 
# How to install
## Running through the shell 
Assuming you have the nix package manager installed, you should be able to run this in a terminal:
`nix run git+https://github.com/PoshestPoro/lr2oraja-endlessdream-nix --impure`
This should install and run lr2oraja-endlessdream
## Nixos
On nixos. in a flake based nix configuration, you should be able to add it as an input like so:
```nix
lr2oraja = {
  url = "github:PoshestPoro/lr2oraja-endlessdream-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

The easiest way to install it from here would be to inherit inputs into a home manager configuration and install it as a package like so:
```nix
inputs.lr2oraja.packages.${pkgs.system}.default
```
### How to run
You should now be able to run it in the terminal with `lr2oraja-endlessdream` or you can run it through the desktop file. 
Make sure to swap your audio backend to port audio.
# Configuration
The configuration for lr2oraja-endlessdream will end up in `~/.local/share/lr2oraja-endlessdream`.
# Repositories used as references
```
https://git.fromouter.space/hamcha/beatoraja-nix/src/branch/master - Base for the flake
https://github.com/huantianad/nixos-config/tree/main - Base for the modules
```

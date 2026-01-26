{ config, lib, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        (pkgs.callPackage ./lr2oraja-endlessdream { 
          libjportaudio =  (pkgs.callPackage ./libjportaudio { });
        })
    ];
}
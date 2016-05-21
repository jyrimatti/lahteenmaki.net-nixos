{ config, lib, pkgs, ... }:

{
  imports = [
    ./nginx.nix
    ./znc.nix
  ]; 

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  
  services.nginx.enable = true;
  services.fcgiwrap.enable = true;

  services.znc.enable = true;
}

{ config, lib, pkgs, ... }:

{
  imports = [
    ./nginx.nix
  ]; 

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  
  services.nginx.enable = true;
}

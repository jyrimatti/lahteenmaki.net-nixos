{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nixos-in-place.nix
    ./services.nix
    ./users.nix
  ];

  environment.systemPackages = [
    pkgs.nox
    pkgs.nix-repl
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  swapDevices = [ { device = "/swap"; } ];

  networking.enableIPv6 = false;
  networking.interfaces.enp0s3.ip4 = [ { address = "146.185.139.29"; prefixLength = 24; } ];
  networking.defaultGateway = "146.185.139.1";
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  networking.hostName = "lahteenmaki.net";
  networking.firewall.allowedTCPPorts = [ 80 443 6667 ];
  networking.extraHosts = "37.136.254.85 aurinkofarmi";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fi";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Helsinki";

  virtualisation.docker.enable = true;

  security.acme.certs."lahteenmaki.net" = {
    webroot = "/var/www";
    email = "jyri-matti@lahteenmaki.net";
    user = "nginx";
    group = "nginx";
    postRun = "systemctl restart nginx.service";
  };

  security.acme.certs."blog.lahteenmaki.net" = {
    webroot = "/var/www";
    email = "jyri-matti@lahteenmaki.net";
    user = "nginx";
    group = "nginx";
    postRun = "systemctl restart nginx.service";
  };

  security.acme.certs."hs.lahteenmaki.net" = {
    webroot = "/var/www";
    email = "jyri-matti@lahteenmaki.net";
    user = "nginx";
    group = "nginx";
    postRun = "systemctl restart nginx.service";
  };

  security.acme.certs."alava.lahteenmaki.net" = {
    webroot = "/var/www";
    email = "jyri-matti@lahteenmaki.net";
    user = "nginx";
    group = "nginx";
    postRun = "systemctl restart nginx.service";
  };

  users.mutableUsers = false;
  users.extraUsers.root.passwordFile = "/root/pwd";

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  programs.zsh.enable = true;

  system.stateVersion = "16.03";

  nix.gc = {
    automatic = true;
    dates = "0 03 * * *";
  };

  nix.extraOptions = ''
    auto-optimise-store = true
  '';
}

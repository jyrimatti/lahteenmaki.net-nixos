{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./users.nix
  ];

  environment.systemPackages = [
    pkgs.nox
    pkgs.ncdu
    pkgs.git
    pkgs.mkpasswd
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  swapDevices = [ { device = "/swap"; } ];

  networking.enableIPv6 = false;
  networking.interfaces.ens3.ipv4.addresses = [ { address = "164.90.230.168"; prefixLength = 20; } ];
  networking.defaultGateway = "164.90.224.1";

  networking.hostName = "lahteenmaki.net";
  networking.firewall.allowedTCPPorts = [ 80 443 6667 ];
  networking.extraHosts = "176.93.30.166 aurinkofarmi";
  networking.nameservers = ["8.8.8.8" "8.8.4.4"];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fi";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Helsinki";

  virtualisation.docker.enable = true;

  security.sudo.enable =  true;
  security.sudo.configFile = ''
    %wheel ALL=(ALL) ALL
  '';

  security.acme.acceptTerms = true;

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

  security.acme.certs."joona.lahteenmaki.net" = {
    webroot = "/var/www";
    email = "jyri-matti@lahteenmaki.net";
    user = "nginx";
    group = "nginx";
    postRun = "systemctl restart nginx.service";
  };

  security.acme.certs."juuso.lahteenmaki.net" = {
    webroot = "/var/www";
    email = "jyri-matti@lahteenmaki.net";
    user = "nginx";
    group = "nginx";
    postRun = "systemctl restart nginx.service";
  };


  security.acme.certs."tkd.lahteenmaki.net" = {
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

  security.acme.certs."binarycache.lahteenmaki.net" = {
    webroot = "/var/www";
    email = "jyri-matti@lahteenmaki.net";
    user = "nginx";
    group = "nginx";
    postRun = "systemctl restart nginx.service";
  };

  security.acme.certs."rafiikka.lahteenmaki.net" = {
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

  system.stateVersion = "18.03";
  system.autoUpgrade.enable = true;

  nix.gc = {
    automatic = true;
    dates = "0 03 * * *";
  };

  nix.extraOptions = ''
    auto-optimise-store = true
  '';

  nix.trustedUsers = ["jyri-matti"];

  nixpkgs.config.allowUnfree = true;
}

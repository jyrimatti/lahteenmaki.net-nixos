# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixos-in-place.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda";

  # List swap partitions that are mounted at boot time.
  swapDevices = [ { device = "/swap"; } ];

  networking.hostName = "lahteenmaki.net"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fi";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = with pkgs; [
  #   wget
  # ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  virtualisation.docker.enable = true;

  systemd.services.nginx = {
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    serviceConfig = {
       ExecStart = ''${pkgs.docker}/bin/docker run --rm --name nginx -p 80:80 --restart="unless-stopped" nginx'';
       ExecStop = ''${pkgs.docker}/bin/docker stop -t 2 nginx'';
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  security.initialRootPassword = "piB7OOuAZ5M08bdS";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.extraUsers.jyri-matti = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDH+RopBjRi4zP4nJ7JbEUXomE0wq50MFYGb5EEwJ6LCT+DZK4QM+Qp97GWB3M1EsZ9rgskSyEf5cWYjXKUZq/70IzYvMM7VICwOnI5pu/6wKNfp+RFu7E7bh5RIdgMAvv7SUUn9ZhEumx+MtvczxSCu7JzYDQ8xpGdlKcfvscxid8XmpvNdntc1HqeTuJfg8axk2vNfK76h7XpWf6/PNKqJFAvcOsv+tRDFeTplxkQYJcaoqgIoDnnM/elW97xRFartPk5LlR2aed0H0QYBalcPDncboquOdzgAFq5oxNO1m9uZT7iG+nBopyr59+EReg4Nb/VVsMnbSd0Q5v/4gS8d9XrJ1hV+/pPkHOlcAwTUh5IQpJoMDauo7Az7Q5fAoozasePN4RcsfxHxVjxty63SaCawHyl1n28Vx6bf/5n7XJRrG6G7iSiisPp9Y8CYFXmkJUUOfxPh/NHa+8wcyrQ18L85SRQsnUAbdQxdFT4obssR6XkZ497WH48/Yfmw/r9EYYleaIhDp90atOnqWVSouhl/dwr2lwTbhzuz2JPWQLImVzEqkhBh8KOeG+2egLjseFSvAmlo2X8WD1rr8L2m3rBYnOSKwG7nNJhYUCsXA5q5HXdJC0EX5c450bD7A7X2+BbzsKlTV+QqFonQHoVbuGuZ3lt8MhyVUgsXUuzIQ== jyri-matti.lahteenmaki@solita.fi"
    ];
  };
  users.extraUsers.root.passwordFile = "/root/pwd";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}

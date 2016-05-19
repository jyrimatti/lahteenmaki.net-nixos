{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixos-in-place.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  swapDevices = [ { device = "/swap"; } ];

  networking.hostName = "lahteenmaki.net"; # Define your hostname.

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fi";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Helsinki";

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

  system.stateVersion = "16.03";

}

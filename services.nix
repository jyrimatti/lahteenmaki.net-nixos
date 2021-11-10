{ config, lib, pkgs, ... }:

{
  imports = [
    ./nginx.nix
    ./znc.nix
    ./minecraft.nix
  ];

  services.postfix = {
    enable = true;
    setSendmail = true;
  };

  services.cron = {
    enable = true;
    mailto = "jyri-matti@localhost";
    systemCronJobs = [
      "*/10 5 * * *    jyri-matti NIXPKGS_ALLOW_UNFREE=1 timeout 10m nix-shell -I channel:nixos-20.03 -p google-chrome --run \"google-chrome-stable --headless --enable-logging --disable-gpu --v=1 --remote-debugging-pipe 'https://rafiikka.lahteenmaki.net/#seed'\" "
      "*/12 5 * * *    jyri-matti NIXPKGS_ALLOW_UNFREE=1 timeout 10m nix-shell -I channel:nixos-20.03 -p google-chrome --run \"google-chrome-stable --headless --enable-logging --disable-gpu --v=1 --remote-debugging-pipe 'https://rafiikka.lahteenmaki.net/#$(date -I --date 'yesterday')T00:00:00Z&seed'\" "
      "*/14 5 * * *    jyri-matti NIXPKGS_ALLOW_UNFREE=1 timeout 10m nix-shell -I channel:nixos-20.03 -p google-chrome --run \"google-chrome-stable --headless --enable-logging --disable-gpu --v=1 --remote-debugging-pipe 'https://rafiikka.lahteenmaki.net/#$(date -I --date 'tomorrow')T00:00:00Z&seed'\" "
      "*/16 5 * * *    jyri-matti NIXPKGS_ALLOW_UNFREE=1 timeout 10m nix-shell -I channel:nixos-20.03 -p google-chrome --run \"google-chrome-stable --headless --enable-logging --disable-gpu --v=1 --remote-debugging-pipe 'https://rafiikka.lahteenmaki.net/#$(date -I --date '+2 days')T00:00:00Z&seed'\" "
    ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  services.nginx.enable = true;
  services.fcgiwrap.enable = true;

  services.znc.enable = true;

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };
}

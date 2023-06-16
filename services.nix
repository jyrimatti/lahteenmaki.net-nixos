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
      "*/10 5 * * *    jyri-matti NIXPKGS_ALLOW_UNFREE=1 timeout 10m nix-shell -I channel:nixos-21.11-small -p google-chrome --run \"google-chrome-stable --headless --enable-logging --disable-gpu --v=1 --remote-debugging-pipe 'https://rafiikka.lahteenmaki.net/#seed'\" "
      "*/12 5 * * *    jyri-matti NIXPKGS_ALLOW_UNFREE=1 timeout 10m nix-shell -I channel:nixos-21.11-small -p google-chrome --run \"google-chrome-stable --headless --enable-logging --disable-gpu --v=1 --remote-debugging-pipe 'https://rafiikka.lahteenmaki.net/#$(date -I --date 'yesterday')T00:00:00Z&seed'\" "
      "*/14 5 * * *    jyri-matti NIXPKGS_ALLOW_UNFREE=1 timeout 10m nix-shell -I channel:nixos-21.11-small -p google-chrome --run \"google-chrome-stable --headless --enable-logging --disable-gpu --v=1 --remote-debugging-pipe 'https://rafiikka.lahteenmaki.net/#$(date -I --date 'tomorrow')T00:00:00Z&seed'\" "
      "*/16 5 * * *    jyri-matti NIXPKGS_ALLOW_UNFREE=1 timeout 10m nix-shell -I channel:nixos-21.11-small -p google-chrome --run \"google-chrome-stable --headless --enable-logging --disable-gpu --v=1 --remote-debugging-pipe 'https://rafiikka.lahteenmaki.net/#$(date -I --date '+2 days')T00:00:00Z&seed'\" "
      "0    * * * *    jyri-matti cd /var/spot && SECURITY_TOKEN=$(cat /home/jyri-matti/.entsoe_token.txt) ./e_load.sh | ./e_parse.sh | ./e_insert.sh"
    ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  services.nginx.enable = true;
  services.nginx.additionalModules = [ pkgs.nginxModules.dav pkgs.nginxModules.moreheaders ];
  services.fcgiwrap.enable = true;

  services.znc.enable = true;

  #services.nix-serve = {
  #  enable = true;
  #  secretKeyFile = "/var/cache-priv-key.pem";
  #};
}

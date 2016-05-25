{ config, lib, pkgs, ... }:

{
  imports = [
    ./nginx.nix
    ./znc.nix
  ];

  services.postfix = {
    enable = true;
    setSendmail = true;
  };

  services.cron = {
    enable = true;
    mailto = "jyri-matti@localhost";
    systemCronJobs = [
      "0 * * * *    jyri-matti source /etc/profile && /var/www/stiebel/simplify.sh /var/www/stiebel/data"
      "1-59 * * * * jyri-matti source /etc/profile && /var/www/stiebel/collect.sh $(cat /home/jyri-matti/stiebel-user) $(cat /home/jyri-matti/stiebel-pass) /var/www/stiebel/data"
    ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  services.nginx.enable = true;
  services.fcgiwrap.enable = true;

  services.znc.enable = true;
}

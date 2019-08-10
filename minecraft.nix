{ config, lib, pkgs, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    jvmOpts = "-Xmx1G -Xms256M";
    package = let 
      version = "1.14.4";
      url = "https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar";
      sha256 = "0aapiwgx9bmnwgmrra9459qfl9bw8q50sja4lhhr64kf7amyvkay";
    in (pkgs.minecraft-server_1_14.overrideAttrs (old: rec {
      name = "minecraft-server-${version}";
      inherit version;

      src = pkgs.fetchurl {
        inherit url sha256;
      };      
    }));
    serverProperties = {
      motd = "Aurinkofarmi Minecraft server!";
    };
  };
}

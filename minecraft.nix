{ config, lib, pkgs, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    jvmOpts = "-Xmx1G -Xms256M";
    whitelist = 
          {
            Night_1 = "a89a22db-ce85-4117-bdd0-79ab31280554";
            pelihullu124 = "2b321f55-669a-49f3-9012-be424fd46ec8";
            JooseQ = "b9552f89-2398-48a3-aa8f-11892c7525ac";
            Sopuli123 = "eb496fa2-ebbd-4da5-9da3-9300d8c0285e";
            Arttuzz888 = "1b724b51-b21d-47dd-b777-4989d4630f81";
          };
    package = let 
      version = "1.18.1";
      url = "https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar";
      sha256 = "1pyvym6xzjb1siizzj4ma7lpb05qhgxnzps8lmlbk00lv0515kgb";
    in (pkgs.minecraft-server.overrideAttrs (old: rec {
      name = "minecraft-server-${version}";
      inherit version;

      src = pkgs.fetchurl {
        inherit url sha256;
      };      
    }));
    serverProperties = {
      motd = "Aurinkofarmi Minecraft server!";
      white-list = true;
    };
  };
}

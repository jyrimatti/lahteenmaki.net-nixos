{ config, lib, pkgs, ... }:

{
  services.netdata = {
    enable = true;
    claimTokenFile = "/root/netdata-claim-token";
    config = {
      global = {
        "update every" = 15;
      };
      ml = {
        "enabled" = "yes";
      };
      db = {
        "mode" = "dbengine"; 
      };
    };

    configDir."stream.conf" =
    let
      mkChildNode = apiKey: ''
        [${apiKey}]
          enabled = yes
          default memory mode = dbengine
          health enabled by default = auto
      '';
    in pkgs.writeText "stream.conf" ''
      [stream]
        enabled = no
        enable compression = yes
      ${mkChildNode "<api-key>"}
    '';
  };
  services.netdata.package = pkgs.netdata.override {
    withCloud = true;
    withCloudUi = true;
  };

}

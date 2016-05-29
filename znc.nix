{ config, lib, pkgs, ... }:

{
  services.znc.confOptions = {
    modules = [ "adminlog" "log" ];
    userModules = [];
    userName = "jyri-matti";
    nick = "Jyppe";
    passBlock = ''
      <Pass password>
	Method = sha256
	Hash = 6151fda6cd44dce9da48ba8a47a0f80c16feb4127ade769a5da3e2c4b712a9bf
	Salt = lxKmezuI2KAxbzaOVVpp
      </Pass>

      <Network ircnet>
        IRCConnectEnabled = true
        Server = openirc.snt.utwente.nl 6667
      </Network>
    '';
    port = 6667;
  };
}

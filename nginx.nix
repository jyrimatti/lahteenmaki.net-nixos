{ config, lib, pkgs, ... }:

{
  services.nginx.config = ''
    http {
      server {
        server_name lahteenmaki.net;
        listen *:80;

        location /.well-known/acme-challenge {
          root /var/www/challenges;
        }

        location / {
          root /var/www;
          #return 301 https://$host$request_uri;
        }
      }

      server {
        server_name lahteenmaki.net;
        listen 443 ssl spdy;
        listen [::]:443 ssl spdy;

        #ssl_certificate /var/lib/acme/lahteenmaki.net/fullchain.pem;
        #ssl_certificate_key /var/lib/acme/lahteenmaki.net/key.pem;

        location / {
          root /var/www;
        }
      }
    }
    events {
    }

  '';
}

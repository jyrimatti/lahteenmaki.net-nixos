{ config, lib, pkgs, ... }:

{
  services.nginx.config = ''
    http {
      charset utf-8;
      index index.html index.txt index.json index.geojson index.xml index.gml index.sh;
      include ${pkgs.nginx}/conf/mime.types;

      dav_ext_lock_zone zone=davlock:10m; 

      fastcgi_index index.sh;
      fastcgi_param QUERY_STRING            $query_string;
      fastcgi_param REQUEST_METHOD          $request_method;
      fastcgi_param CONTENT_TYPE            $content_type;
      fastcgi_param CONTENT_LENGTH          $content_length;
      fastcgi_param SCRIPT_FILENAME         $document_root$fastcgi_script_name;
      fastcgi_param SCRIPT_NAME             $fastcgi_script_name;
      fastcgi_param PATH_INFO               $fastcgi_path_info;
      fastcgi_param PATH_TRANSLATED         $document_root$fastcgi_path_info;
      fastcgi_param REQUEST_URI             $request_uri;
      fastcgi_param DOCUMENT_URI            $document_uri;
      fastcgi_param DOCUMENT_ROOT           $document_root;
      fastcgi_param SERVER_PROTOCOL         $server_protocol;
      fastcgi_param GATEWAY_INTERFACE       CGI/1.1;
      fastcgi_param SERVER_SOFTWARE         nginx/$nginx_version;
      fastcgi_param REMOTE_ADDR             $remote_addr;
      fastcgi_param REMOTE_PORT             $remote_port;
      fastcgi_param SERVER_ADDR             $server_addr;
      fastcgi_param SERVER_PORT             $server_port;
      fastcgi_param SERVER_NAME             $server_name;
      fastcgi_param HTTPS                   $https;

      fastcgi_param PATH                    /home/jyri-matti/.local/nix-override:/run/current-system/sw/bin/;

      resolver 8.8.8.8;

      gzip            on;
      gzip_types application/xhtml+xml text/plain application/xml text/xml application/json application/javascript text/javascript text/css application/vnd.geo+json application/x-java-serialized-object application/pdf application/x-ndjson text/csv;

      fastcgi_cache_path /var/cache/nginx/fastcgi1 keys_zone=fastcgi1:50m max_size=400m inactive=7d;
      fastcgi_cache_path /var/cache/nginx/fastcgi2 keys_zone=fastcgi2:50m max_size=400m inactive=7d;
      fastcgi_cache_path /var/cache/nginx/fastcgi3 keys_zone=fastcgi3:50m max_size=400m inactive=7d;
      fastcgi_cache_key "$scheme$request_method$host$request_uri";

      proxy_cache_path /var/cache/nginx/dtinfra keys_zone=dtinfra:10m max_size=400m inactive=30d;
      proxy_cache_path /var/cache/nginx/dtjeti keys_zone=dtjeti:10m max_size=100m inactive=30d;

      proxy_read_timeout 300s;

      map $http_Digitraffic_User $dtuser {
        default "lahteenmaki.net/proxied";
        ~. $http_Digitraffic_User;
      }

      server {
        server_name blog.lahteenmaki.net;
        
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/blog.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/blog.lahteenmaki.net/key.pem;

        location / {
          add_header Access-Control-Allow-Origin *;
          if ($request_method = OPTIONS ) {
            add_header Access-Control-Allow-Origin *;
            add_header Access-Control-Allow-Headers 'origin, x-requested-with, content-type, accept, hx-current-url, hx-request';
            add_header Access-Control-Allow-Methods 'GET';
            return 200;
          }
          root /var/blog;
        }

        location ~ "^/([0-9]*)/([0-9]*)/" {
          rewrite ^/$ https://blog.lahteenmaki.net/ permanent;
        }
      }

      server {
        server_name blog.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

        location / {
          root /var/blog;
          return 301 https://$host$request_uri;
        }

      }

      server {
        server_name hs.lahteenmaki.net;

        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/hs.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/hs.lahteenmaki.net/key.pem;

        location / {
          root /var/hs;
        }
      }

      server {
        server_name hs.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

        location / {
          root /var/hs;
          return 301 https://$host$request_uri;
        }

      }

      server {
        server_name joona.lahteenmaki.net;

        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/joona.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/joona.lahteenmaki.net/key.pem;

        location / {
          root /var/joona;
        }
      }

      server {
        server_name joona.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

        location / {
          root /var/joona;
          return 301 https://$host$request_uri;
        }

      }


      server {
        server_name juuso.lahteenmaki.net;

        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/juuso.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/juuso.lahteenmaki.net/key.pem;

        location / {
          root /var/juuso;

        }
      }

      server {
        server_name juuso.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

        location / {
          root /var/juuso;
          return 301 https://$host$request_uri;
        }

      }

      server {
        server_name spot.lahteenmaki.net;
         
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/spot.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/spot.lahteenmaki.net/key.pem;

        location ~ ^/[^/]*[.]csv$ {
          root /var/spot;
          fastcgi_cache fastcgi1;
          add_header X-Cache-status $upstream_cache_status;
          if (-f $request_filename) {
            fastcgi_pass unix:/run/fcgiwrap.sock;
          }
        }
        location ~ ^/[^/]*[.]json$ {
          root /var/spot;
          fastcgi_cache fastcgi2;
          add_header X-Cache-status $upstream_cache_status;
          if (-f $request_filename) {
            fastcgi_pass unix:/run/fcgiwrap.sock;
          }
        }
        location /current.html {
          root /var/spot;
          fastcgi_cache fastcgi3;
          add_header X-Cache-status $upstream_cache_status;
          if (-f $request_filename) {
            fastcgi_pass unix:/run/fcgiwrap.sock;
          }
        }
        location /day.html {
          root /var/spot;
          fastcgi_cache fastcgi3;
          add_header X-Cache-status $upstream_cache_status;
          if (-f $request_filename) {
            fastcgi_pass unix:/run/fcgiwrap.sock;
          }
        }
        location /window.html {
          root /var/spot;
          fastcgi_cache fastcgi3;
          add_header X-Cache-status $upstream_cache_status;
          if (-f $request_filename) {
            fastcgi_pass unix:/run/fcgiwrap.sock;
          }
        }

        location /spot.db {
          root /var/spot;
          gzip off;
        }

        location / {
          root /var/spot;
          expires 0;
          add_header Cross-Origin-Embedder-Policy "require-corp";
          add_header Cross-Origin-Opener-Policy "same-origin";         
        }
      }

      server {
        server_name spot.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

        location / {
          root /var/spot;
          return 301 https://$host$request_uri;
        }

      }

      server {
        server_name tkd.lahteenmaki.net;
         
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/tkd.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/tkd.lahteenmaki.net/key.pem;

        location / {
          root /var/tkd;
        }
      }

      server {
        server_name tkd.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

        location / {
          root /var/tkd;
          return 301 https://$host$request_uri;
        }

      }

      server {
        server_name alava.lahteenmaki.net;
        
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/alava.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/alava.lahteenmaki.net/key.pem;

        location / {
          root /var/alava;
        }
      }

      server {
        server_name alava.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

        location / {
          root /var/alava;
          return 301 https://$host$request_uri;
        }
      }

      server {
        server_name binarycache.lahteenmaki.net;
        
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/binarycache.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/binarycache.lahteenmaki.net/key.pem;

        location / {
          proxy_pass http://localhost:${toString config.services.nix-serve.port};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
        }
      }

      server {
        server_name binarycache.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

	location / {
          return 301 https://$host$request_uri;
        }
      }

# force cache rafiikka api call redirecets because otherwise safari doesn't cache redirect targets
map $upstream_http_cache_control $cachecontrol {
    "~."    $upstream_http_cache_control;
    default "public, max-age=3600";
}

      server {
        server_name rafiikka.lahteenmaki.net;
        
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/rafiikka.lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/rafiikka.lahteenmaki.net/key.pem;

        location / {
          root /var/rafiikka;
          add_header Cache-Control "public, must-revalidate";
          add_header Last-Modified "";
        }

	location /infra-api/ {
                set $upstream rata.digitraffic.fi; # using variable, to make Nginx start even if host not found
    		proxy_pass https://$upstream$request_uri;
		proxy_cache dtinfra;
		add_header X-Cache-status $upstream_cache_status;
		proxy_set_header Digitraffic-User $dtuser;
                proxy_set_header Host $host;
		proxy_hide_header Cache-Control;
		add_header Cache-Control $cachecontrol;
	}

        location @check_header {
          if ($upstream_http_content_type = "text/css;charset=UTF-8") {
            return 400 "Only text/event-stream allowed.";
          }
          return 200;
        }

	location /jeti-api/ {
                set $upstream rata.digitraffic.fi; # using variable, to make Nginx start even if host not found
    		proxy_pass https://$upstream$request_uri;
		proxy_cache dtjeti;
		add_header X-Cache-status $upstream_cache_status;
		proxy_set_header Digitraffic-User $dtuser;
                proxy_set_header Host $host;
		proxy_hide_header Cache-Control;
		add_header Cache-Control $cachecontrol;
	}

      }

      server {
        server_name rafiikka.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

	location / {
          return 301 https://$host$request_uri;
        }
      }


      server {
        server_name lahteenmaki.net www.lahteenmaki.net;

        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        ssl_certificate /var/lib/acme/lahteenmaki.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/lahteenmaki.net/key.pem;

        location /stiebel {
          root /var/www;
          gzip off;
          auth_basic "Restricted Content";
          auth_basic_user_file /etc/nixos/.htpasswd;
        }

        location /spot {
          root /var/www;
          rewrite ^/$ http://spot.lahteenmaki.net redirect;
        }

        location / {
          root /var/www;
        }

        location /blog {
          rewrite ^/$ https://blog.lahteenmaki.net redirect;
        }

        location /hs {
          rewrite ^/$ https://hs.lahteenmaki.net redirect;
        }

        location /tkd {
          rewrite ^/$ http://tkd.lahteenmaki.net redirect;
        }

        location /alava {
          rewrite ^/$ https://alava.lahteenmaki.net redirect;
        }

        location /rafiikka {
          rewrite ^/$ https://rafiikka.lahteenmaki.net redirect;
        }

        location /uitesteri/ {
          root /var/www/;
          add_header Access-Control-Allow-Origin *;
        }

        location /.well-known/webfinger {
          root /var/www/;
          types { } default_type "application/jrd+json;charset=utf-8";
        }

        location /davtest/ {
          root                  /var/www/;
          dav_methods           PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods       PROPFIND OPTIONS;
          dav_ext_lock          zone=davlock;
          autoindex             on;

          dav_access            all:r;
        }

#        location ~ "^/http(s?)/(rata\.digitraffic\.fi|www\.lupapiste\.fi)(/)(.*)" {
#          resolver 8.8.8.8;
#          proxy_pass http$1://$2$3$4$is_args$args;
#          proxy_set_header Accept-Encoding "";
#          proxy_hide_header X-Frame-Options;
#          proxy_redirect '/' '/http$1/$2$3';
#          proxy_redirect 'http://$2' '/http/$2';
#          proxy_redirect 'https://$2' '/https/$2';
#          sub_filter 'href="/' 'href="/http$1/$2/';
#          sub_filter 'href=\'/' 'href=\'/http$1/$2/';
#          sub_filter 'src="/' 'src="/http$1/$2/';
#          sub_filter 'src=\'/' 'src=\'/http$1/$2/';
#          sub_filter 'action="/' 'action="/http$1/$2/';
#          sub_filter 'action=\'/' 'action=\'/http$1/$2/';
#          sub_filter '"http://$2/' '"/http/$2/';
#          sub_filter '"http://$2' '"/http/$2/';
#          sub_filter '"https://$2/' '"/https/$2/';
#          sub_filter '"https://$2' '"/https/$2/';
#          sub_filter '\'http://$2/' '\'/http/$2/';
#          sub_filter '\'http://$2' '\'/http/$2/';
#          sub_filter '\'https://$2/' '\'/https/$2/';
#          sub_filter '\'https://$2' '\'/https/$2/';
#          sub_filter '</body>' '<script type="text/javascript" src="/uitesteri/uitesteri.js"></script></body>';
#          sub_filter_once off;
#          sub_filter_types text/html;
#        }

        location /24-days-2012/ {
          root /var/www;
          autoindex on;
        }

        location /bus-tre {
          set $upstream api.publictransport.tampere.fi; # using variable, to make Nginx start even if host not found
          if ($request_uri ~* "/bus-tre(.*$)") {
              set $path_remainder $1;
          }
          proxy_pass http://$upstream/1_0_2$path_remainder;
        }
        location /bus-hsl {
          set $upstream api.reittiopas.fi; # using variable, to make Nginx start even if host not found
          if ($request_uri ~* "/bus-hsl(.*$)") {
              set $path_remainder $1;
          }
          proxy_pass http://$upstream/hsl/prod$path_remainder;
        }
        location /bus-siri {
          set $upstream siri.ij2010.tampere.fi; # using variable, to make Nginx start even if host not found
          if ($request_uri ~* "/bus-siri(.*$)") {
              set $path_remainder $1;
          }
          proxy_pass https://$upstream/ws$path_remainder;
        }
        location /bus-json {
          set $upstream data.itsfactory.fi; # using variable, to make Nginx start even if host not found
          if ($request_uri ~* "/bus-json(.*$)") {
              set $path_remainder $1;
          }
          proxy_pass http://$upstream/siriaccess/vm/json$path_remainder;
        }
        location /goodreads/ {
          set $upstream www.goodreads.com; # using variable, to make Nginx start even if host not found
          if ($request_uri ~* "/goodreads(/.*$)") {
              set $path_remainder $1;
          }
          proxy_pass https://$upstream/review/list_rss$path_remainder;
        }

        location /tyorako/ {
          root /var/www/;
          add_header Cache-Control "public, no-cache";

          location /tyorako/seed.txt {
            fastcgi_pass unix:/run/fcgiwrap.sock;
          }
        }

	location /infra-api/ {
                set $upstream rata.digitraffic.fi; # using variable, to make Nginx start even if host not found
    		proxy_pass https://$upstream$request_uri;
		proxy_cache dtinfra;
		add_header X-Cache-status $upstream_cache_status;
		proxy_set_header Digitraffic-User $dtuser;
                proxy_set_header Host $upstream;
                proxy_ssl_server_name on;
                proxy_http_version 1.1;
		proxy_hide_header Cache-Control;
		add_header Cache-Control "public, max-age=3600, immutable";
	}

	location /beta-infra-api/ {
                set $upstream rata-beta.digitraffic.fi; # using variable, to make Nginx start even if host not found
    		if ($request_uri ~* "/beta-infra-api(/.*$)") {
              	  set $path_remainder $1;
          	}
		proxy_pass https://$upstream/infra-api$path_remainder;
		proxy_cache dtinfra;
		add_header X-Cache-status $upstream_cache_status;
		proxy_set_header Digitraffic-User $dtuser;
                proxy_set_header Host $upstream;
                proxy_ssl_server_name on;
                proxy_http_version 1.1;
                proxy_set_header X-Forwarded-Prefix "/beta-infra-api";
		proxy_hide_header Cache-Control;
		add_header Cache-Control "public, max-age=3600, immutable";
	}

	location /jeti-api/ {
                set $upstream rata.digitraffic.fi; # using variable, to make Nginx start even if host not found
    		proxy_pass https://$upstream$request_uri;
		proxy_cache dtjeti;
		add_header X-Cache-status $upstream_cache_status;
		proxy_set_header Digitraffic-User $dtuser;
                proxy_set_header Host $upstream;
                proxy_ssl_server_name on;
                proxy_http_version 1.1;
		proxy_hide_header Cache-Control;
		add_header Cache-Control "public, max-age=3600, immutable";
	}

	location /beta-jeti-api/ {
                set $upstream rata-beta.digitraffic.fi; # using variable, to make Nginx start even if host not found
    		if ($request_uri ~* "/beta-jeti-api(/.*$)") {
                  set $path_remainder $1;
                }
                proxy_pass https://$upstream/jeti-api$path_remainder; 
		proxy_cache dtjeti;
		add_header X-Cache-status $upstream_cache_status;
		proxy_set_header Digitraffic-User $dtuser;
                proxy_set_header Host $upstream;
                proxy_ssl_server_name on;
                proxy_http_version 1.1;
                proxy_set_header X-Forwarded-Prefix "/beta-jeti-api";
		proxy_hide_header Cache-Control;
		add_header Cache-Control "public, max-age=3600, immutable";
	}

      }

      server {
        server_name lahteenmaki.net www.lahteenmaki.net;

        listen *:80;

        location /.well-known/acme-challenge/ {
          root /var/www;
        }

        location / {
          root /var/www;
          return 301 https://$host$request_uri;
        }

      }
    }
    events {
    }

  '';
}

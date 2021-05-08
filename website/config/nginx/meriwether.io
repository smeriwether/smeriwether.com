server {
  listen 80;
  listen 443 ssl; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/meriwether.io/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/meriwether.io/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

  server_name meriwether.io www.meriwether.io;

  return 301 https://stephen.fyi$request_uri;
}

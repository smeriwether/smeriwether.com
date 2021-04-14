server {
  listen 443 ssl; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/merimerimeri.com/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/merimerimeri.com/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

  server_name merimerimeri.com www.merimerimeri.com;

  return 301 https://world.hey.com/smeriwether;
}

server {
  if ($host = www.merimerimeri.com) {
      return 301 https://$host$request_uri;
  } # managed by Certbot


  if ($host = merimerimeri.com) {
      return 301 https://$host$request_uri;
  } # managed by Certbot


  listen 80;

  server_name merimerimeri.com www.merimerimeri.com;

  return 404; # managed by Certbot
}





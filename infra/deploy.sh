#!/bin/sh

echo "Cleaning up local directory..."

rm -rf ./site/*
mkdir ./site/

echo "Compiling site (production)..."

PROD=true ruby ./compiler/make.rb

echo "Copying files to server..."

scp -rp $WEBSITE/site/* $WEBSITE_SERVER:/var/www/smeriwether.com
scp -rp $WEBSITE/infra/nginx.conf $WEBSITE_SERVER:/etc/nginx/sites-enabled/smeriwether.com
scp -rp $WEBSITE/infra/redirect.nginx.conf $WEBSITE_SERVER:/etc/nginx/sites-enabled/srm.dev

echo "Restarting NGINX..."

ssh $WEBSITE_SERVER "sudo systemctl restart nginx"

echo "Cleaning up local directory..."

rm -rf ./site/*


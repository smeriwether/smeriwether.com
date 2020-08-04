#!/bin/bash

echo "Cleaning up local directory..."

rm -rf ./site/*
mkdir ./site/

echo "Compiling site (production)..."
echo "bundle exec ruby!"

PROD=true bundle exec ruby ./compiler/make.rb
if [ $? == 1 ]; then
  echo "Build command failed"
  exit 1
fi

echo "Copying files to server..."

scp -o StrictHostKeyChecking=no -rp $WEBSITE/site/* $WEBSITE_SERVER:/var/www/smeriwether.com
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi
scp -o StrictHostKeyChecking=no -rp $WEBSITE/infra/nginx.conf $WEBSITE_SERVER:/etc/nginx/sites-enabled/smeriwether.com
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi
scp -o StrictHostKeyChecking=no -rp $WEBSITE/infra/redirect.nginx.conf $WEBSITE_SERVER:/etc/nginx/sites-enabled/srm.dev
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi

echo "Restarting NGINX..."

ssh $WEBSITE_SERVER "sudo systemctl restart nginx"
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi

echo "Cleaning up local directory..."

rm -rf ./site/*


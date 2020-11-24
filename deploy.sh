#!/bin/bash

echo "Building..."

NODE_ENV=production ./build.sh

echo "Deploying..."

scp -o StrictHostKeyChecking=no -rp $WEBSITE/site/* $WEBSITE_SERVER:/var/www/stephen.fyi
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi

scp -o StrictHostKeyChecking=no -rp $WEBSITE/nginx/stephen.fyi $WEBSITE_SERVER:/etc/nginx/sites-enabled/stephen.fyi
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi

scp -o StrictHostKeyChecking=no -rp $WEBSITE/nginx/srm.dev $WEBSITE_SERVER:/etc/nginx/sites-enabled/srm.dev
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi

scp -o StrictHostKeyChecking=no -rp $WEBSITE/nginx/smeriwether.com $WEBSITE_SERVER:/etc/nginx/sites-enabled/smeriwether.com
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi

echo "Cleaning up..."

ssh $WEBSITE_SERVER "sudo systemctl restart nginx"
if [ $? == 1 ]; then
  echo "Deploy failed"
  exit 1
fi

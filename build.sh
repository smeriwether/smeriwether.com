#!/bin/bash

rm -rf ./site

npx postcss --config=./config/postcss.config.js ./styles.css -o ./site/styles.css

ruby build.rb

if [[ $NODE_ENV == "production" ]]; then
  for file in ./site/*.html; do
    mv -- "$file" "${file%%.html}"
  done
fi

cp -R ./public ./site

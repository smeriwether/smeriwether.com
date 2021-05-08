#!/bin/bash

rm -rf ./site

npx postcss --config=./website/config/postcss.config.js ./website/styles.css -o ./site/styles.css

ruby ./website/build.rb

if [[ $NODE_ENV == "production" ]]; then
  for file in ./site/*.html; do
    mv -- "$file" "${file%%.html}"
  done
fi

cp -R ./public ./site

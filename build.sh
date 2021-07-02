#!/bin/bash

rm -rf ./site

npm install

npx postcss --config=./postcss.config.js ./styles.css -o ./site/styles.css

mv index.html ./site/index.html
mv 404.html ./site/404.html

if [[ $NODE_ENV == "production" ]]; then
  for file in ./site/*.html; do
    mv -- "$file" "${file%%.html}"
  done
fi

cp -R ./public ./site

#!/bin/bash

rm -rf ./site/*

npm run build

ruby main.rb

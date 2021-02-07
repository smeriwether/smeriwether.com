# stephen.fyi

[stephen.fyi](https://stephen.fyi) is my home on the internet. It's a simple static site that's served via NGINX
on a DigitalOcean droplet.

## To make changes ("build")

1. Update *something*, one of the html files, add a new public item, etc.
2. Run `npm run build`

Optional: 
Run `npm run open` to open the homepage in a web browser.


## To deploy to DigitalOcean

1. Set a `$WEBSITE_SERVER` env var to username@password of the DigitalOcean droplet
2. Run `npm run deploy`

Note:
The website will automatically deploy when the `main` branch is updated on Github.


## Copyright & Fair Use

The content and design of this website is [copyrighted](https://www.copyright.gov/help/faq/faq-general.html#mywork). Feel 
free to ask if you want to reuse any content beyond the bounds of [fair use](https://www.copyright.gov/fair-use/more-info.html).

## Build status

[![CircleCI](https://circleci.com/gh/smeriwether/stephen.fyi.svg?style=svg)](https://circleci.com/gh/smeriwether/stephen.fyi)

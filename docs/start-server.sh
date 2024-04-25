#!/bin/sh
podman run --rm -it -p 4000:4000 -v $PWD:/site:Z site:latest /bin/sh -c "bundle install && bundle exec jekyll serve --host 0.0.0.0 --incremental  --force_polling --drafts"


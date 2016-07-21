# run with:
# docker run -it --name jekyll -v $HOME/code/lathonez.github.io:/srv/jekyll -p 4000:4000 lathonez/jekyll /bin/bash
# bundle exec jekyll serve --host 0.0.0.0

from ubuntu:16.04

MAINTAINER lathonez

RUN \
    apt-get update; \
    apt-get install -y -qq gcc; \
    apt-get install -y -qq git; \
    apt-get install -y -qq libxml2-dev; \
    apt-get install -y -qq libxslt-dev; \
    apt-get install -y -qq make; \
    apt-get install -y -qq ruby-full; \
    apt-get install -y -qq zlib1g-dev;

RUN \
	gem install nokogiri -- --use-system-libraries; \
	gem install jekyll; \
	gem install bundle;

RUN \
	git clone https://github.com/lathonez/lathonez.github.io.git; \
	cd lathonez.github.io; \
	bundle install;
#!/bin/sh
cd /home/app
bundle exec rake db:migrate db:seed

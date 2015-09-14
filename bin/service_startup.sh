#!/bin/bash

source /etc/profile.d/rvm.sh

resque-pool --daemon --environment production start
/var/www/unicorn/current/bin/bundle exec "unicorn_rails -c config/unicorn.rb -E production"


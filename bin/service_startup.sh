#!/bin/bash

source /home/unicorn/.profile

resque-pool --daemon --environment production start
/var/www/unicorn/bin/bundle exec "unicorn_rails -c config/unicorn.rb -E production"


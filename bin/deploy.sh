#!/bin/bash

bundle exec 'cap production deploy'
ssh -i ~/.ssh/id_sufia-dev.osfashland.org unicorn@sufia-dev.osfashland.org 'sudo systemctl restart unicorn'


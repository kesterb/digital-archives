#!/bin/bash

cap production deploy
ssh -i ~/.ssh/id_sufia-dev.osfashland.org deploy@sufia-dev.osfashland.org 'sudo systemctl restart unicorn'


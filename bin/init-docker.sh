#!/bin/bash

sudo docker run -d -p 8080:8080 --name fedora4 andrewkrug/fedora4
sudo docker run -d -p 8081:8080 --name solr joelferrier/solr


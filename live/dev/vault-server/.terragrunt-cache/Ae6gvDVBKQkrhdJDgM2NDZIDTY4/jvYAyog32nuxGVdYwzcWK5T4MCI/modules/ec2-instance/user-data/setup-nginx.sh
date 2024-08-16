#!/bin/bash

apt-get update && sudo apt-get install -y nginx
service nginx start
echo "NGINX INSTALLED"
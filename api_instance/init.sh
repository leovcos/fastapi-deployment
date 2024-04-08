#!/bin/bash

# git clone https://github.com/leovcos/fastapi-deployment.git fastapi

cd fastapi

mkdir --parents /var/www/fastapi
mv src /var/www/fastapi
mv requirements.txt /var/www/fastapi

cd /var/www/fastapi

python3 -m venv env
source env/bin/activate
pip3 install -r requirements.txt

chown  www-data:www-data -R /var/www
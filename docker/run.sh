#!/bin/bash

dir=$(pwd)
cd $(dirname "${BASH_SOURCE[0]}")
cp Dockerfile ..
cd ..

# Build
docker build -t lapis/langid .

# Run
secret=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
docker run -d -p 3000:80 --name langid -e SECRET_KEY_BASE=$secret lapis/langid

echo
docker ps | grep 'langid'
echo

echo '-----------------------------------------------------------'
echo 'Now go to your browser and access http://localhost/api'
echo '-----------------------------------------------------------'

rm Dockerfile
cd $dir

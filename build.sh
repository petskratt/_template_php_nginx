#!/usr/bin/env bash

# always start in script's directory, exit if fails
cd "${0%/*}" || exit 1

source .env

# install app dependencies
#composer install --working-dir ./src
npm install --prefix ./src/assets

# generate selfsigned certs
if [ ! -f ./conf/server.key ] || [ ! -f ./conf/server.crt ]; then
  openssl req -x509 -newkey rsa:4096 -keyout ./conf/server.key -out ./conf/server.crt -sha256 -days 3650 -nodes -subj "/C=EE/ST=Torgu Kuningriik/L=Torgu vald/O=Iseallkirjastuv Sertifitseerimisasutus/OU=Fiktiivsete dokumentide valmendamise osakond/CN=*.$BASENAME" -addext "subjectAltName = DNS:$BASENAME"
  echo "Generated certs"
  openssl x509 -in server.crt -text -noout
fi

# build image
docker build -t "$BASENAME-app" ./
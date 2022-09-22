#!/bin/sh

VERSION_TAG=`cat VERSION`
docker tag samba-timemachine:local jgnagy/samba-timemachine:$VERSION_TAG
docker tag samba-timemachine:local jgnagy/samba-timemachine:latest
docker push jgnagy/samba-timemachine:$VERSION_TAG
docker push jgnagy/samba-timemachine:latest

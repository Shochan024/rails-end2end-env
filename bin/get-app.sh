#!/bin/bash
export $(cat ../.env | xargs)

git clone $REPOSITORY ../repo/$APPNAME
mkdir -p ../repo/${APPNAME}/tmp/sockets
mkdir -p ../repo/${APPNAME}/tmp/pids

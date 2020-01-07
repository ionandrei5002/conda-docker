#!/bin/bash

userid=$(id -u)
groupid=$(id -g)
username=$(whoami)

docker build \
    --build-arg userid="$userid" \
    --build-arg groupid="$groupid" \
    --build-arg username="$username" \
    --rm -f "Dockerfile" \
    -t conda-docker:latest .
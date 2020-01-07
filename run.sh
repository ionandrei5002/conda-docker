#!/bin/bash

username=$(whoami)

docker run --rm -it -e DISPLAY=$DISPLAY \
    -v /home/$username/conda-builds:/home/$username/conda-builds \
    conda-docker:latest
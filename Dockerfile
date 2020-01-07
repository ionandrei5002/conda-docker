FROM ubuntu:18.04

# ARGS
ARG userid
ARG groupid
ARG username

# SET NONINTERACTIVE
ENV DEBIAN_FRONTEND "noninteractive"

# RUN STUFF AS ROOT
USER root

RUN apt update && \
    apt install -y \
    locate \
    locales \
    wget \
    sudo

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US
ENV LC_ALL en_US.UTF-8

RUN apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN mkdir -p /home/$username \
    && echo "$username:x:$userid:$groupid:$username,,,:/home/$username:/bin/bash" >> /etc/passwd \
    && echo "$username:x:$userid:" >> /etc/group \
    && mkdir -p /etc/sudoers.d \
    && echo "$username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$username \
    && chmod 0440 /etc/sudoers.d/$username \
    && chown $userid:$groupid -R /home/$username \
    && chmod 777 -R /home/$username \
    && usermod -a -G $username www-data

# UNSET NONINTERACTIVE
ENV DEBIAN_FRONTEND ""

USER $username
ENV SHELL /bin/bash
ENV HOME /home/$username
WORKDIR /home/$username

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3.sh && \
    bash miniconda3.sh -b -p $HOME/miniconda3

RUN /bin/bash -c "source $HOME/miniconda3/bin/activate" && \
    /bin/bash -c "$HOME/miniconda3/bin/conda init" && \
    /bin/bash -c "$HOME/miniconda3/bin/conda update conda -y" && \
    /bin/bash -c "$HOME/miniconda3/bin/conda install conda-build git patch gcc_linux-64 gxx_linux-64 -y"
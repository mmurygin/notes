#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install -y build-essential

declare -r INSTALL_DIR="${HOME}"

# install PRCE
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.gz && \
    tar -zxf pcre-8.41.tar.gz  && \
    cd pcre-8.41  && \
    ./configure  && \
    make  && \
    sudo make install

cd "$INSTALL_DIR"

# install zlib
wget http://zlib.net/zlib-1.2.11.tar.gz  && \
    tar -zxf zlib-1.2.11.tar.gz  && \
    cd zlib-1.2.11  && \
    ./configure  && \
    make  && \
    sudo make install

cd "$INSTALL_DIR"

# install openssl
wget http://www.openssl.org/source/openssl-1.0.2k.tar.gz  && \
    tar -zxf openssl-1.0.2k.tar.gz  && \
    cd openssl-1.0.2k  && \
    ./configure linux-x86_64 --prefix=/usr  && \
    make  && \
    sudo make install


# Dockerfile for dev environment

FROM ubuntu
MAINTAINER Manish Jain <manishrjain@gmail.com>
RUN apt-get update && apt-get install -y \
 ack-grep \
 bzr \
 cmake \
 curl \
 g++ \
 git \
 make \
 man-db \
 mercurial \
 ncurses-dev \
 procps \
 python-dev \
 python-pip \
 ssh \
 sudo \
 tmux \
 unzip \
 vim \
 xz-utils \
 && rm -rf /var/lib/apt/lists/*

RUN pip install ipython

# Store your favourite bashrc config, and copy it over.
# WARNING: If you don't have a bashrc, this step would fail.
COPY bashrc /root/.bashrc

RUN mkdir /installs
# Install Golang1.5.1
RUN cd /installs && \
wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.5.1.linux-amd64.tar.gz

# Golang App Engine SDK
RUN cd /installs && /usr/bin/env python -V 2>&1 | grep 2.7 && \
wget https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.25.zip && \
unzip go_appengine_sdk_linux_amd64-1.9.25.zip

ENV GOPATH /go
ENV GOBIN /go/bin
ENV PATH /usr/local/go/bin:/go/bin:/installs/go_appengine:$PATH
ENV HOME /root
WORKDIR /go/src

RUN go version | grep go1.5

# OPTIONAL: Compile vim from scratch if need be. Vim installed via apt-get as above, already comes with python interpreter, which is required by YouCompleteMe vim plugin.
# RUN hg clone https://vim.googlecode.com/hg/ /root/vim
# RUN cd /root/vim && \
# ./configure --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config && \
# make && make install

# Vundle: Vim plugin manager
RUN git clone https://github.com/gmarik/Vundle.vim.git /root/.vim/bundle/Vundle.vim

# YouCompleteMe: This plugin takes the longest time to download all its deps. So, let's do the downloading as a separate step.
RUN git clone https://github.com/Valloric/YouCompleteMe.git /root/.vim/bundle/YouCompleteMe
RUN cd /root/.vim/bundle/YouCompleteMe && git submodule update --init --recursive \
 && ./install.sh --clang-completer

# OPTIONAL STEP: Uncomment them if you want to install rsa key for easier access to your git repos.
# RUN mkdir /root/.ssh
# WARNING: The following step would FAIL if you don't have the rsa file.
# ADD bitbucket_gmail_key_id_rsa /root/.ssh/id_rsa
# RUN chmod 0600 /root/.ssh/id_rsa
# RUN touch /root/.ssh/known_hosts
# RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

# RUN mkdir -p /go/src
# You wouldn't want to clone a git repository that you want to edit from within the docker environment.
# It's best to clone it on the machine, and then mount it in your docker dev env.
# That way your changes are persisted, even if you stop the docker container.
# You can do so via passing '-v ~/path/to/source:/go/src' to docker run command.
# Following is NOT RECOMMENDED:
# RUN cd /go/src && git clone git@bitbucket.org:username/repo.git
RUN git config --global credential.helper 'cache --timeout=86400'

# VIM
COPY vimrc /root/.vimrc
RUN vim +PluginInstall  +qall
RUN vim +GoInstallBinaries +qall

# Change timezone
RUN ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

# Set lib-path for gocode: This is required so you get auto-complete on appengine golang libraries.
RUN gocode set lib-path "/installs/go_appengine/goroot/pkg/linux_amd64_appengine"

# CMD ["/bin/bash"]
CMD ["tmux", "-u2"]

# Run Docker with
# sudo docker run -i -t -v ~/workspace/src:/go/src testing2

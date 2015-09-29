FROM ubuntu:14.04.2

ENV OS_USER_NAME codecheck

RUN apt-get install -y software-properties-common aptitude
RUN apt-add-repository -y ppa:ansible/ansible
RUN apt-get update -y
RUN apt-get install -y ansible git curl

WORKDIR /root
RUN bash -c 'cp .bashrc .bashrc.old'
RUN bash -c ': > .bashrc'
RUN git clone https://github.com/code-check/env-builder.git
WORKDIR /root/env-builder
RUN ansible-playbook -i "localhost," -c local codecheck.yml
WORKDIR /root

# Node.js
# https://github.com/nodejs/docker-node/blob/d798690bdae91174715ac083e31198674f044b68/0.12/wheezy/Dockerfile
RUN set -ex \
	&& for key in \
		7937DFD2AB06298B2293C3187D33FF9D0246406D \
		114F43EE0176B71C7BC219DD50A3051F888C628D \
	; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done
ENV NODE_VERSION 0.12.7
ENV NPM_VERSION 2.14.1
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear
RUN npm install -g grunt-cli gulp codecheck mocha

# Recover bashrc
RUN bash -c 'cat .bashrc.old >> .bashrc'
RUN bash -c 'rm .bashrc.old'
RUN bash -c 'cat .bashrc >> .profile'

# scala environment
WORKDIR /root/tmp
RUN sbt -sbt-version 0.13.5
RUN sbt -sbt-version 0.13.6
RUN sbt -sbt-version 0.13.7
RUN sbt -sbt-version 0.13.8
RUN sbt -sbt-version 0.13.9
RUN git clone https://github.com/skohar/cache-for-scala-sbt.git
RUN cd cache-for-scala-sbt && git checkout scala2.11.7-sbt-1.13.5 && sbt compile
WORKDIR /root
RUN rm -r /root/tmp

# python environment with pyenv
RUN apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev
RUN git clone https://github.com/yyuu/pyenv.git .pyenv
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN pyenv install 2.7.10
RUN pyenv global 2.7.10
RUN pyenv rehash
RUN pip install nose
RUN pyenv install 3.4.3
RUN pyenv global 3.4.3
RUN pyenv rehash
RUN pip install nose

RUN gem install rspec
ENV PATH /root/.gem/ruby/2.2.0/bin:$PATH


FROM php:7.2-cli

ARG BUILD_DATE
ARG VCS_REF

ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV NVM_DIR=/root/.nvm

LABEL org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.vcs-url="https://github.com/ptope/docker-laravel-python.git" \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.schema-version="1.0" \
	org.label-schema.vendor="polytope.dk" \
	org.label-schema.name="docker-laravel-python" \
	org.label-schema.description="Docker for Laravel in a CI environment with Python" \
	org.label-schema.url="https://github.com/ptope/docker-laravel-python"

ENV NVM_VERSION v0.33.9

RUN apt-get update

# Required to add yarn package repository
RUN apt-get install -y apt-transport-https gnupg2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
	libbz2-dev \
	libmcrypt-dev \
	git \
	unzip \
	wget \
	libpng-dev \
	libgconf-2-4 \
	libfontconfig1 \
	chromium \
	xvfb \
	yarn \
	python3 \
	python3-pip

RUN docker-php-ext-install -j$(nproc) \
	bcmath \
	bz2 \
	calendar \
	exif \
	gd \
	#mcrypt \
	pcntl \
	pdo_mysql \
	shmop \
	sockets \
	sysvmsg \
	sysvsem \
	sysvshm \
	zip

RUN pecl install xdebug-2.6.0
RUN docker-php-ext-enable xdebug

RUN mkdir -p $NVM_DIR && \
	curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

RUN . ~/.nvm/nvm.sh && \
	nvm install lts/carbon && \
	nvm alias default lts/carbon

RUN apt-get update && \
	apt-get install -y --no-install-recommends git zip

RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

CMD ["php", "-a"]
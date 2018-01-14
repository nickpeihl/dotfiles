#!/bin/bash
set -e
set -o pipefail

# install.sh
#  Install the basic setup for my debian laptop

export DEBIAN_FRONTEND=noninteractive

# Choose a user account to use for this installation
get_user() {
	if [ -z "${TARGET_USER-}" ]; then
		PS3='Which user account should be used? '
		options=($(find /home/* -maxdepth 0 -printf "%f\n" -type d))
		select opt in "${options[@]}"; do
			readonly TARGET_USER=$opt
			break
		done
	fi
}

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}

setup_sources_min() {
	apt-get update
	apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		dirmngr \
		lsb-release \
		--no-install-recommends
}

setup_sources() {
	setup_sources_min
}

base_min() {
	apt-get update
	apt-get -y upgrade

	apt-get install -y \
		adduser \
		automake \
		bash-completion \
		bc \
		bzip2 \
		ca-certificates \
		curl \
		dnsutils \
		file \
		findutils \
		gcc \
		git \
		gnupg \
		gnupg2 \
		gnupg-agent \
		grep \
		gzip \
		hostname \
		indent \
		iptables \
		jq \
		less \
		libc6-dev \
		locales \
		lsof \
		mount \
		net-tools \
		rxvt-unicode-256color \
		ssh \
		strace \
		sudo \
		tar \
		unzip \
		xclip \
		xcompmgr \
		zip \
		--no-install-recommends

	apt-get autoremove
	apt-get autoclean
	apt-get clean

}

base() {
	base_min;
	apt-get install -y \
		xdg-utils \
		--no-install-recommends
	
}

install_emacs() {
	# install emacs core
	apt-get update

	apt-get install -y \
		emacs25
	
	# install prelude
	export PRELUDE_INSTALL_DIR=/home/${TARGET_USER}/.dotfiles/.emacs.d && curl -L https://github.com/bbatsov/prelude/raw/master/utils/installer.sh | sh

	sudo systemctl enable "emacs@${TARGET_USER}"
}

install_wmapps() {
	local pkgs=( feh i3 i3lock i3status scrot slim suckless-tools )

	apt-get install -y "${pkgs[@]}" --no-install-recommends
}

get_user
base
install_emacs
install_wmapps

#!/bin/sh

. _LIBRARY_PATH_/install/logging.sh

# shfmt
if [ $(env | grep -c ^OS=Windows.*$) -gt 0 ]; then
	GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
elif [ $(uname | grep -c FreeBSD) -gt 0 ]; then
	pkg info -e shfmt

	if [ $? -eq 1 ]; then
		info "installing shfmt"
		$_SUDO_PROGRAM pkg install -y shfmt
	else
		info "shfmt is already installed"
	fi
else
	info "Please install shfmt"
fi

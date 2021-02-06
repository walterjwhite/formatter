#!/bin/sh

_build_files() {
	dirname $(grep -l "package main" $(find . -type f | grep \\.go$)) |
		sort -u
}

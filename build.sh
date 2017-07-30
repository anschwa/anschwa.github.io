#!/usr/bin/env sh

path="site/"

# start fresh
rm -rf $path
mkdir $path

# check if wget is installed
command -v wget > /dev/null 2>&1 || { echo "Do you have wget installed?" >&2; exit 1; }

# Build the static site
wget --directory-prefix $path --recursive --domains 0:5000 0:5000 --no-host-directories
wget --directory-prefix $path --recursive --domains 0:5000 0:5000/blog/ --no-host-directories
wget --directory-prefix $path --recursive --domains 0:5000 0:5000/projects/ --no-host-directories

# fetch static resources
wget --directory-prefix $path 0:5000/style.css
wget --directory-prefix $path 0:5000/me.jpg

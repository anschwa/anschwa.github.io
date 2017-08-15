#!/usr/bin/env sh

path="site/"

# start fresh
rm -rf $path
mkdir $path

# check if wget is installed
command -v wget > /dev/null 2>&1 || { echo "Do you have wget installed?" >&2; exit 1; }

# Build the static site
pages=("blog/" "projects/" "style.css" "me.jpg")

for x in "${pages[@]}"
do
    wget --directory-prefix $path --recursive --domains 0:5000 "0:5000/$x" --no-host-directories
done

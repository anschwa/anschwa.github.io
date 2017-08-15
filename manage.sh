#!/usr/bin/env bash

# Build and deploy my personal site
path="build"

######## BUILD ########
function build {
    # backup old build
    cp -r $path "$path.bak"

    # start fresh
    rm -rf $path
    mkdir -p $path

    # check if wget is installed
    command -v wget > /dev/null 2>&1 || { echo "Do you have wget installed?" >&2; exit 1; }

    # Build the static site
    pages=("blog/" "projects/" "style.css" "me.jpg")

    for x in "${pages[@]}"
    do
        wget --directory-prefix $path --recursive --domains 0:5000 "0:5000/$x" --no-host-directories
    done

    # copy CNAME file
    cp CNAME $path/CNAME
}

######## DEPLOY ########
# Deploy to GitHub Pages
function deploy {
    ghp-import -b master -m "[deploy] Build" -p $path
}

######## MAIN ########
if [ $1 ] && [ $1 = "build" ]; then
    build
elif [ $1 ] && [ $1 = "deploy" ]; then
    build
    deploy
else
    echo "You must specify a valid option."
    echo "Usage: $0 [build|deploy]"
fi

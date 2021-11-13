#!/bin/bash
set -euo pipefail

# Process images and create thumbnails
# WARNING: Before running this script you should strip EXIF data from
# the images and make sure each photo is oriented correctly.

usage="Usage: ./make-thumbnails.sh DIRECTORY"
if [ "$#" -ne 1 ]
then
    echo "${usage}"
    exit 1
fi

img_dir="${1}"
if ! [ -d "${img_dir}" ]
then
    echo "Error: ${img_dir} is not a directory"
    echo "${usage}"
    exit 1
fi

if ! [ -x "$(command -v mogrify)" ]
then
    echo "Error: mogrify is not available. Please install imagemagick to continue"
    exit 1
fi

# Reduce file size of all images
# WARNING this will overwrite the original files
mogrify -quality 50 "${img_dir}/*.jpg"

# Crete thumbnails
mkdir -p "${img_dir}/thumbs"
mogrify -path "${img_dir}/thumbs" -thumbnail 400x -quality 100 "${img_dir}/*.jpg"

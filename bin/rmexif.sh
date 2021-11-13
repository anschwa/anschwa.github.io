#!/bin/bash

set -euo pipefail

# Strip all EXIF data from images in a directory
# WARNING this will overwrite the original files

if ! [ -x "$(command -v exiftool)" ]
then
    echo "Error: exiftool is not available"
    exit 1
fi

exiftool -overwrite_original -all:all= -r "$1"

# -*- coding: utf-8 -*-

# Configure flask settings to be hosted by github if desired.
# If you do not want this capability, simply comment out the repective lines.

# python 3 import support
from __future__ import absolute_import

import os

REPO_NAME = "adamschwartz.io"  # Used for FREEZER_BASE_URL
DEBUG = True

# Assumes the app is located in the same directory
# where this file resides
APP_DIR = os.path.dirname(os.path.abspath(__file__))


def parent_dir(path):
    '''Return the parent of a directory.'''
    return os.path.abspath(os.path.join(path, os.pardir))

PROJECT_ROOT = parent_dir(APP_DIR)

# Github Configuration Start:
# In order to deploy to Github pages, you must build the static files to
# the project root

FREEZER_DESTINATION = PROJECT_ROOT

# Since this is a repo page (not a Github user page),
# we need to set the BASE_URL to the correct url as per GH Pages' standards
FREEZER_BASE_URL = "http://localhost/{0}".format(REPO_NAME)

FREEZER_REMOVE_EXTRA_FILES = False  # IMPORTANT: If this is True, all app files
                                    # will be deleted when you run the freezer
# Github configuration End:

# url_for() returns relative URLs.
# This enable the frozen site to be browsed locally,
# but appends a visible index.html to URLs that would otherwise end with /.
FREEZER_RELATIVE_URLS = False  # change to False if on a server

FLATPAGES_ROOT = os.path.join(APP_DIR, 'pages')
FLATPAGES_EXTENSION = '.markdown'

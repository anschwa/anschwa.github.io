# -*- coding: utf-8 -*

import os

try:
    # Assumes package is located in the same directory
    # where this file resides
    APP_DIR = os.path.dirname(os.path.abspath(__file__))
except:
    APP_DIR = ""


def parent_dir(path):
    return os.path.abspath(os.path.join(path, os.pardir))

DEBUG = True
PROJECT_ROOT = parent_dir(APP_DIR)
# Where to build static files to
FREEZER_DESTINATION = os.path.join(PROJECT_ROOT, 'build')
FLATPAGES_ROOT = os.path.join(PROJECT_ROOT, 'pages')
FLATPAGES_EXTENSION = '.markdown'

REPO_NAME = "adamschwartz.io" 
BASE_URL = 'http://daschwa.github.io/'
GITHUB_REPO = 'http://www.github.com/daschwa/daschwa.github.io'

# View site locally
FREEZER_RELATIVE_URLS = False

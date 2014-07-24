# -*- coding: utf-8 -*-

'''Entry point to all things to avoid circular imports.'''

# python 3 import support
from __future__ import absolute_import

from .app import app, freezer, pages
from webapp.routes import *
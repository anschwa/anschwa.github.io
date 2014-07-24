# -*- coding: utf-8 -*-

# python 3 import support
from __future__ import absolute_import

from flask import Flask
from flask_flatpages import FlatPages
from flask_frozen import Freezer

app = Flask(__name__)
app.config.from_pyfile('settings.py')
pages = FlatPages(app)
freezer = Freezer(app)

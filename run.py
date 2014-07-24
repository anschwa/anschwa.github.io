# -*- coding: utf-8 -*-

# python 3 import support
from __future__ import absolute_import

import os
from webapp import main
# could also use "from webapp.main import *"
# and call with "app.run()" directly

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    main.app.run(host='0.0.0.0', port=port)

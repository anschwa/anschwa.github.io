daschwa.github.io
=================

My personal [website](http://daschwa.github.io/), powered by [Flask](http://flask.pocoo.org/) and hosted on [GitHub Pages](https://pages.github.com/).


# Project Setup

## Virtualenv
* `sudo pip install virtualenv`
* `cd my_flask_project`
* `virtualenv venv`    

## Requirements
Start by creating a requirements.txt file with following: (with each package on it's own line)

* [Flask](http://flask.pocoo.org/)
* [flask-flatpages](http://pythonhosted.org/Flask-FlatPages/)
* [frozen-flask](https://pythonhosted.org/Frozen-Flask/)   

Then install these packages into your virtual environment.

* `venv/bin/pip install -r requirements.txt`
* `ven/bin/pip freeze -r requirements.txt > requirements.txt`

This replaces your limited requirements with a more complete 
list with correct version numbers for later use.

## Running
There are two options for running this flask webapp.

You can run it as a dynamically generated server with `run.py`. Or, you can create a static version of your site with `freeze.py` that can be hosted anywhere.

With either case, you need to ensure that you run the file with the correct python environment, in this case it's our virtualenv called 'venv'. 

We run them like this:

*  `/path/to/venv/bin/python run.py`

or

* `/path/to/venv/bin/python freeze.py`

I like to set an alias in `.bash_profile` or `.bashrc` to make things easier.

    # virtualenv alias
    alias vpython="venv/bin/python"
    
# Helpful Tutorials
- Steven Loria's [Hosting static Flask sites for free on Github Pages](http://stevenloria.com/hosting-static-flask-sites-for-free-on-github-pages/)
- James Harding's [Build a Simple, Static, Markdown-Powered Blog with Flask](http://www.jamesharding.ca/posts/simple-static-markdown-blog-in-flask/)
- Nicolas Perriault's [Dead easy yet powerful static website generator with Flask](https://nicolas.perriault.net/code/2012/dead-easy-yet-powerful-static-website-generator-with-flask/)



daschwa.github.io
=================

My personal [website](http://daschwa.github.io/), powered by [Flask](http://flask.pocoo.org/) and hosted on [GitHub Pages](https://pages.github.com/).


# Project Setup

Clone the repo

```
$ git clone https://github.com/daschwa/daschwa.github.io.git
```

Install the necessary Python packages (requires Python 2.7 or 3.4.n with pip):

```
# After activating your virtualenv
$ pip install -r requirements.txt
```

### Building the site

To run the local development server

```
$ python manage.py runserver
```

You can browse to `http://localhost:5000/` to view the site.

To build the static version of the site:

```
$ python manage.py build
```

This will build the static site to the `build/` directory.

### Deployment

To deploy to GitHub Pages:

```
$ python manage.py deploy
```

This will build the site, commit to the `master` branch, and push to GitHub.
    
# References
- Steven Loria's [Hosting static Flask sites for free on Github Pages](http://stevenloria.com/hosting-static-flask-sites-for-free-on-github-pages/)
- Steven Loria's [KillTheYak](http://github.com/killtheyak/killtheyak)
- James Harding's [Build a Simple, Static, Markdown-Powered Blog with Flask](http://www.jamesharding.ca/posts/simple-static-markdown-blog-in-flask/)
- Nicolas Perriault's [Dead easy yet powerful static website generator with Flask](https://nicolas.perriault.net/code/2012/dead-easy-yet-powerful-static-website-generator-with-flask/)

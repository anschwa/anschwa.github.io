# -*- coding: utf-8 -*-

# python 3 import support
from __future__ import absolute_import

from datetime import datetime
from calendar import month_name
from flask import render_template, abort
from .app import app, pages


# quick function to sort posts.
def sort_my_posts(posts):
    # Sort pages by date
    return sorted(posts, reverse=True, key=lambda page: page.meta['date'])

########## Assign Variables. ##########
nav_items = ['Blog', 'Projects', "Archive",
             ['GitHub', 'https://github.com/daschwa']]


########## Context Processors ##########
@app.context_processor
def inject_copy_year():
    """A simple function to pass the current
       year as a variable to the base template"""
    return dict(copy_year=datetime.now().year)


########## Start assigning routes / views. ##########
@app.route('/')
def home():
    return render_template('base.html', title='Home',
                           nav_items=nav_items, homepage='homepage')


@app.route('/blog/')
def blog():
    # get all files in pages/blog, including sub-directories
    posts = [page for page in pages if
             page.path.startswith('blog') if 'date' in page.meta]
    # Sort pages by date
    sorted_posts = sort_my_posts(posts)
    # only post the latest 3 entries.
    home_posts = sorted_posts[:6]

    return render_template('blog.html', title='Blog', posts=home_posts,
                           nav_items=nav_items)


@app.route('/about/')  # use trailing slash to specify a directory for freeze
def about():
    content = [page for page in pages if
               page.meta['title'] == 'About' if 'date' in page.meta]

    return render_template('simple.html', title='About', content=content[0],
                           nav_items=nav_items)


@app.route('/projects/')
def projects():
    content = [page for page in pages if
               page.meta['title'] == 'Projects' if 'date' in page.meta]

    return render_template('simple.html', title='Projects', content=content[0],
                           nav_items=nav_items)


@app.route('/prefs/')
def prefs():
    return render_template('prefs.html', title='Display Preferences',
                           nav_items=nav_items)


@app.route('/archive/')
# TODO
# To sort archives properly, try keeping numerical dates,
# turn the dict into a list, then make date names at the end.
def archive():
    # First define our archive building function.
    def make_date_dict(dates, date_dict):
        """Generate a dict of posts by month from a list of dates."""
        # month_year = dates[0][:7]

        # add the dates.
        for date in dates:
            year = date.year
            month = date.month
            isodate = date.isoformat()
            # create a long string for the archive title
            # this is to sort the posts with a jinja filter
            archive_title = isodate+' '+month_name[month]+' '+str(year)
            # matches a list of all posts that have the same year and month
            # This seems to crate duplicates, so we need to remove them.
            match_posts = [page for page in pages if
                           page.path.startswith('blog')
                           if page.meta['date'].month == month]
            # add post to the correct date key
            date_dict[archive_title] = match_posts

            archive_dict = {}

            # Remove the duplicates from the dictionary
            for key, value in date_dict.items():
                if value not in archive_dict.values():
                    archive_dict[key] = value

        return archive_dict

    # Now build the archive dictionary

    posts = [page for page in pages if
             page.path.startswith('blog') if 'date' in page.meta]
    # important to pass a sorted list of dates to make dict
    # so the page loads quickly
    sorted_posts = sort_my_posts(posts)
    dates = [page.meta['date'] for page in sorted_posts]

    date_dict = {}
    date_dict_no_sort = make_date_dict(dates, date_dict)

    # Sort the dates of the listed posts.
    date_dict_sorted = {}
    for key in date_dict_no_sort.iterkeys():
        date_dict_sorted[key] = sort_my_posts(date_dict_no_sort[key])

    # sorted by posts only
    archives = date_dict_sorted

    # finally send our archive to the template
    return render_template('archive.html', title='Archive',
                           archives=archives, nav_items=nav_items)


# generate a route for each file in the pages directory
@app.route('/<path:page_path>/')
def view_page(page_path):
    # `page_path` is the filename of a page without the file extension.
    # e.g. "first-post"

    # make sure the page is not in nav_items and therefore routed already
    if pages.get(page_path) not in nav_items:
        page = pages.get_or_404(page_path)
        # get title of singleton list of posts.
        # used to reuse page.html
        title = page.meta['title']

        return render_template('post.html', posts=[page], title=title,
                               nav_items=nav_items)
    else:
        abort(404)

# routes for the rest of the site

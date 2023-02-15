# highlight-css

This repository hosts CSS files for Pygments-compatible styles.

Primarily these are the styles built into [Pygments](http://pygments.org), with a few more from [Rouge](https://github.com/rouge-ruby/rouge) (which is used by [Jekyll](https://github.com/jekyll/jekyll)).

build
-----

To build the stylesheets and docs, just run `make`. You will need some `ruby` (I'm using 3.1.1) and some `python` (3.10.8).

New styles built into Pygments and/or Rouge will be automatically detected by the [Makefile](https://github.com/numist/highlight-css/blob/main/Makefile).

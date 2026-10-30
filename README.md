# highlight-css

This repository hosts CSS files for Pygments-compatible styles.

Primarily these are the styles built into [Pygments](http://pygments.org), with a few more from [Rouge](https://github.com/rouge-ruby/rouge) (which is used by [Jekyll](https://github.com/jekyll/jekyll)).

build
-----

To rebuild the stylesheets and docs, just run `make`. You will need some `python3` (with `venv` support) and some `ruby` with `bundler`, plus a C compiler (on macOS, the Xcode Command Line Tools) because one of Rouge's dependencies builds a native extension. Dependencies are installed into the project (`.venv` and `vendor/bundle`), so no global packages are needed. This is mostly useful before merging @dependabot dependency update PRs.

# ABOUTME: Builds CSS stylesheets and docs previews from every Pygments style and Rouge theme.
# ABOUTME: Installs Python and Ruby dependencies into the project (.venv and vendor/bundle).

$(VERBOSE).SILENT:
.DELETE_ON_ERROR:

#
# Phony targets
#

PAGES_PATH = docs

.DEFAULT_GOAL := all

#
# Dependencies
#

PYTHON_ENV = .venv
RUBY_ENV = vendor/bundle
export BUNDLE_PATH := $(RUBY_ENV)

$(PYTHON_ENV)/installed: requirements.txt
	echo "Installing dependencies from $<"
	python3 -m venv $(PYTHON_ENV)
	$(PYTHON_ENV)/bin/pip install --disable-pip-version-check -r $< > /dev/null
	touch $@

$(RUBY_ENV)/installed: Gemfile.lock
	echo "Installing dependencies from $<"
	bundle install > /dev/null
	touch $@

#
# Styles
#

# Make remakes this included file (installing dependencies first) and then
# restarts, so the style lists below come from the project's own dependencies.
STYLES_MAKEFILE = styles.mk
-include $(STYLES_MAKEFILE)

$(STYLES_MAKEFILE): $(PYTHON_ENV)/installed $(RUBY_ENV)/installed
	echo "Listing styles"
	$(PYTHON_ENV)/bin/python -c "from pygments.styles import get_all_styles; print('PYGMENTS_STYLES :=', *get_all_styles())" > $@
	bundle exec ruby -r rouge -e 'puts "ROUGE_STYLES := " + (Rouge::CSSTheme.subclasses + Rouge::CSSTheme.subclasses.map(&:subclasses)).flatten.map(&:name).join(" ")' >> $@

#
# Pygments
#

PYGMENTS_STYLESHEET_PATH = Pygments
PYGMENTS_STYLESHEETS := $(PYGMENTS_STYLES:%=$(PYGMENTS_STYLESHEET_PATH)/%.css)

PYGMENTS_PREVIEW_PATH = $(PAGES_PATH)/stylesheets/pygments
PYGMENTS_PREVIEWS := $(PYGMENTS_STYLES:%=$(PYGMENTS_PREVIEW_PATH)/%.css)

$(PYGMENTS_STYLESHEETS): $(PYTHON_ENV)/installed
	echo "Building: $@"
	$(eval style=$(basename $(notdir $@)))
	echo "/* This file was generated using \`pygmentize -S $(style) -f html -a .highlight\` */" > $@
	$(PYTHON_ENV)/bin/pygmentize -S $(style) -f html -a .highlight >> $@

$(PYGMENTS_PREVIEWS): $(PYTHON_ENV)/installed
	echo "Building: $@"
	$(eval style=$(basename $(notdir $@)))
	$(PYTHON_ENV)/bin/pygmentize -S $(style) -f html -a .highlight-pygments-$(style) > $@

Pygments: $(PYGMENTS_STYLESHEETS) $(PYGMENTS_PREVIEWS)

#
# Rouge
#

ROUGE_STYLESHEET_PATH = Rouge
ROUGE_STYLESHEETS := $(ROUGE_STYLES:%=$(ROUGE_STYLESHEET_PATH)/%.css)

ROUGE_PREVIEW_PATH = $(PAGES_PATH)/stylesheets/rouge
ROUGE_PREVIEWS := $(ROUGE_STYLES:%=$(ROUGE_PREVIEW_PATH)/%.css)

$(ROUGE_STYLESHEETS): $(RUBY_ENV)/installed
	echo "Building: $@"
	$(eval style=$(basename $(notdir $@)))
	echo "/* This file was generated using \`rougify style $(style)\` */" > $@
	bundle exec rougify style $(style) >> $@

$(ROUGE_PREVIEWS): $(RUBY_ENV)/installed
	echo "Building: $@"
	$(eval style=$(basename $(notdir $@)))
	set -o pipefail; bundle exec rougify style $(style) | sed -e 's/.highlight/.highlight-rouge-$(shell echo $(style) | sed -e 's/\./\\\\\./')/' > $@

Rouge: $(ROUGE_STYLESHEETS) $(ROUGE_PREVIEWS)

#
# GitHub Pages
#

# Generated stylesheets for styles missing from the style lists, removed so
# that the docs only list styles that are still built.
ORPHANED_STYLESHEETS := $(filter-out $(PYGMENTS_STYLESHEETS) $(PYGMENTS_PREVIEWS) $(ROUGE_STYLESHEETS) $(ROUGE_PREVIEWS),$(wildcard $(PYGMENTS_STYLESHEET_PATH)/*.css $(PYGMENTS_PREVIEW_PATH)/*.css $(ROUGE_STYLESHEET_PATH)/*.css $(ROUGE_PREVIEW_PATH)/*.css))

$(PAGES_PATH)/index.md: $(STYLES_MAKEFILE) $(PYGMENTS_PREVIEWS) $(ROUGE_PREVIEWS)
	for file in $(ORPHANED_STYLESHEETS); do echo "Removing: $$file"; rm -f "$$file"; done
	echo "Updating: $@"
	./$(PAGES_PATH)/scripts/update_front_matter.rb

#
# Phony targets
#

.PHONY: all clean list

all: $(STYLES_MAKEFILE) Pygments Rouge $(PAGES_PATH)/index.md

list:
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

clean:
	rm $(PYGMENTS_STYLESHEET_PATH)/*.css $(ROUGE_STYLESHEET_PATH)/*.css $(PAGES_PATH)/stylesheets/{pygments,rouge}/*.css ||:
	./$(PAGES_PATH)/scripts/update_front_matter.rb

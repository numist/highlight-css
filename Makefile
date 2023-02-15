$(VERBOSE).SILENT:

#
# Phony targets
#

.PHONY: all clean list FORCE

all: gh-pages/index.md

list:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

clean:
	rm "$(PYGMENTS_STYLESHEET_PATH)"/*.css &> /dev/null ||:
	rm Rouge/*.css &> /dev/null ||:
	rm gh-pages/stylesheets/{pygments,rouge}/*.cs &> /dev/null ||:
	./gh-pages/scripts/update_front_matter.rb

requirements.txt: FORCE
	echo "Dependency: $@"
	pip install -r requirements.txt

Gemfile.lock: FORCE
	echo "Install: $@ dependencies"
	bundle install

FORCE:

#
# Pygments
#

PYGMENTS_STYLESHEET_PATH = "Pygments"
PYGMENTS_STYLESHEETS := $(shell python3 -c "from pygments.styles import get_all_styles; print('\n'.join([f'$(PYGMENTS_STYLESHEET_PATH)/{style}.css' for style in list(get_all_styles())]))")

PYGMENTS_PREVIEW_PATH = "gh-pages/stylesheets/pygments"
PYGMENTS_PREVIEWS := $(shell python3 -c "from pygments.styles import get_all_styles; print('\n'.join([f'$(PYGMENTS_PREVIEW_PATH)/{style}.css' for style in list(get_all_styles())]))")

$(PYGMENTS_STYLESHEETS): requirements.txt
	echo "Building: $@"
	$(eval style=$(basename $(notdir $@)))
	echo "/* This file was generated using \`pygmentize -S $(style) -f html -a .highlight\` */" > $@
	pygmentize -S $(style) -f html -a .highlight >> $@

$(PYGMENTS_PREVIEWS): requirements.txt
	echo "Building: $@"
	$(eval style=$(basename $(notdir $@)))
	pygmentize -S $(style) -f html -a .highlight-pygments-$(style) > $@

Pygments: $(PYGMENTS_STYLESHEETS) $(PYGMENTS_PREVIEWS)

#
# Rouge
#

ROUGE_STYLESHEET_PATH = "Rouge"
ROUGE_STYLESHEETS := $(shell ruby -r rouge -e 'puts (Rouge::CSSTheme.subclasses + Rouge::CSSTheme.subclasses.map(&:subclasses)).flatten.map(&:name).map{ |style| $(ROUGE_STYLESHEET_PATH)+"/"+style+".css" }')

ROUGE_PREVIEW_PATH = "gh-pages/stylesheets/rouge"
ROUGE_PREVIEWS := $(shell ruby -r rouge -e 'puts (Rouge::CSSTheme.subclasses + Rouge::CSSTheme.subclasses.map(&:subclasses)).flatten.map(&:name).map{ |style| $(ROUGE_PREVIEW_PATH)+"/"+style+".css" }')

$(ROUGE_STYLESHEETS): Gemfile.lock
	echo "Building: $@"
	$(eval style=$(basename $(notdir $@)))
	echo "/* This file was generated using \`rougify style $(style)\` */" > $@
	rougify style $(style) >> $@

$(ROUGE_PREVIEWS): Gemfile.lock
	echo "Building: $@"
	$(eval style=$(basename $(notdir $@)))
	rougify style $(style) | sed -e 's/.highlight/.highlight-rouge-$(shell echo $(style) | sed -e 's/\./-/')/' > $@

Rouge: $(ROUGE_STYLESHEETS) $(ROUGE_PREVIEWS)

#
# GitHub Pages
#

gh-pages/index.md: Pygments Rouge
	echo "Updating: $@"
	./gh-pages/scripts/update_front_matter.rb

$(VERBOSE).SILENT:

# Lists of all style names supported by each tool
PYGMENTS_STYLES := $(shell python3 -c "from pygments.styles import get_all_styles; print(\"\n\".join(list(get_all_styles())))")
ROUGE_STYLES := $(shell ruby -r rouge -e 'puts (Rouge::CSSTheme.subclasses + Rouge::CSSTheme.subclasses.map(&:subclasses)).flatten.map(&:name)')

# Generate stylesheets for drop-in use in Jekyll and other sites
pygmentize_gen_css = echo "/* This file was generated using \`pygmentize -S $(style) -f html -a .highlight\` */" > Pygments/$(style).css; pygmentize -S $(style) -f html -a .highlight >> Pygments/$(style).css;
rouge_gen_css = echo "/* This file was generated using \`rougify style $(style)\` */" > Rouge/$(shell echo $(style) | sed -e 's/\./-/').css; rougify style $(style) >> Rouge/$(shell echo $(style) | sed -e 's/\./-/').css;

# Generate stylesheets with custom classes prefixed by ".highlight-$(family)-$(style)"
pygmentize_gen_preview_css = pygmentize -S $(style) -f html -a .highlight-pygments-$(style) > gh-pages/stylesheets/pygments/$(style).css;
rouge_gen_preview_css = rougify style $(style) | sed -e 's/.highlight/.highlight-rouge-$(shell echo $(style) | sed -e 's/\./-/')/' > gh-pages/stylesheets/rouge/$(shell echo $(style) | sed -e 's/\./-/').css;



#
# Phony targets
#
# TODO: probably `deps` could be broken into two file targets (`Gemfile.lock` and `requirements.txt`) but clean builds don't take very long so there's not much point at the moment

.PHONY: all deps

all: Pygments Rouge gh-pages/index.md

deps:
	echo "Installing dependencies: rouge pygments"
	bundle install > /dev/null
	pip install -v -r requirements.txt > /dev/null

#
# GitHub Pages
#

gh-pages/index.md: gh-pages/stylesheets/pygments gh-pages/stylesheets/rouge
	echo "Updating: $@"
	./gh-pages/scripts/update_front_matter.rb

#
# Pygments
#

Pygments: deps
	echo "Building: CSS files for $@"
	mkdir -p $@
	rm $@/*.css &> /dev/null
	$(foreach style, $(PYGMENTS_STYLES), $(pygmentize_gen_css))

gh-pages/stylesheets/pygments: deps
	echo "Building: CSS files for $@"
	mkdir -p $@
	rm $@/*.css &> /dev/null
	$(foreach style, $(PYGMENTS_STYLES), $(pygmentize_gen_preview_css))

#
# Rouge
#

Rouge: deps
	echo "Building: CSS files for $@"
	mkdir -p $@
	rm $@/*.css &> /dev/null
	$(foreach style, $(ROUGE_STYLES), $(rouge_gen_css))

gh-pages/stylesheets/rouge: deps
	echo "Building: CSS files for $@"
	mkdir -p $@
	rm $@/*.css &> /dev/null
	$(foreach style, $(ROUGE_STYLES), $(rouge_gen_preview_css))


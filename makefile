# Lists of all style names supported by each tool
PYGMENTS_STYLES := $(shell python3 -c "from pygments.styles import get_all_styles; print(\"\n\".join(list(get_all_styles())))")
ROUGE_STYLES := $(shell ruby -r rouge -e 'puts (Rouge::CSSTheme.subclasses + Rouge::CSSTheme.subclasses.map(&:subclasses)).flatten.map(&:name)')

# Generate stylesheets for drop-in use in Jekyll and other sites
pygmentize_gen_css = echo "/* This file was generated using \`pygmentize -S $(style) -f html -a .highlight\` */" > Pygments/$(style).css; pygmentize -S $(style) -f html -a .highlight >> Pygments/$(style).css;
rouge_gen_css = echo "/* This file was generated using \`rougify style $(style)\` */" > Rouge/$(shell echo $(style) | sed -e 's/\./-/').css; rougify style $(style) >> Rouge/$(shell echo $(style) | sed -e 's/\./-/').css;

all: deps rouge pygments gh-pages

deps:
	bundle install
	pip install -v -r requirements.txt

pygments: deps
	$(foreach style, $(PYGMENTS_STYLES), $(pygmentize_gen_css))

rouge: deps
	$(foreach style, $(ROUGE_STYLES), $(rouge_gen_css))

gh-pages: FORCE
	$(MAKE) -C $@ all

FORCE:

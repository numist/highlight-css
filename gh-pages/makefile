# Lists of all style names supported by each tool
PYGMENTS_STYLES := $(shell python3 -c "from pygments.styles import get_all_styles; print(\"\n\".join(list(get_all_styles())))")
ROUGE_STYLES := $(shell ruby -r rouge -e 'puts (Rouge::CSSTheme.subclasses + Rouge::CSSTheme.subclasses.map(&:subclasses)).flatten.map(&:name)')

# Generate stylesheets with custom classes prefixed by ".highlight-$(family)-$(style)"
pygmentize_gen_css = pygmentize -S $(style) -f html -a .highlight-pygments-$(style) > stylesheets/pygments/$(style).css;
rouge_gen_css = rougify style $(style) | sed -e 's/.highlight/.highlight-rouge-$(shell echo $(style) | sed -e 's/\./-/')/' > stylesheets/rouge/$(shell echo $(style) | sed -e 's/\./-/').css;

all: markdown

deps:
	BUNDLE_GEMFILE=../Gemfile bundle install
	pip install -v -r ../requirements.txt

pygments: deps
	mkdir -p stylesheets/pygments
	$(foreach style, $(PYGMENTS_STYLES), $(pygmentize_gen_css))

rouge: deps
	mkdir -p stylesheets/rouge
	$(foreach style, $(ROUGE_STYLES), $(rouge_gen_css))

markdown: pygments rouge
	./scripts/update_front_matter.rb

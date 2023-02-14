$(VERBOSE).SILENT:

# make sure you already ran pip install -r requirements.txt
#
# syntax
# pygmentize -S <style> -f <formatter> [-a <arg>] [-O <options>] [-P <option=value>]
# (pygmentize documentation is pretty scattered and confusing, but the "-a" will add other classes
# to the output)

PYGMENTS_STYLES := $(shell python3 -c "from pygments.styles import get_all_styles; print(\"\n\".join(list(get_all_styles())))")
ROUGE_STYLES := $(shell ruby -r rouge -e 'puts (Rouge::CSSTheme.subclasses + Rouge::CSSTheme.subclasses.map(&:subclasses)).flatten.map(&:name)')

# a recursively-expanding variable, so that its value contains an actual function call to be
# re-expanded under the control of foreach
pygmentize_gen_html = pygmentize -S $(style) -f html -a .highlight-pygments-$(style) > stylesheets/pygments/$(style).css;
rouge_gen_html = rougify style $(style) | sed -e 's/.highlight/.highlight-rouge-$(shell echo $(style) | sed -e 's/\./-/')/' > stylesheets/rouge/$(shell echo $(style) | sed -e 's/\./-/').css;

all: deps rouge pygments markdown

deps:
	bundle install
	pip install -v -r requirements.txt

pygments:
	mkdir -p stylesheets/pygments
	$(foreach style, $(PYGMENTS_STYLES), $(pygmentize_gen_html))

rouge:
	mkdir -p stylesheets/rouge
	$(foreach style, $(ROUGE_STYLES), $(rouge_gen_html))

markdown:

	./scripts/update_front_matter.rb

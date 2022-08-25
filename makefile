$(VERBOSE).SILENT:

# make sure you already ran pip install -r requirements.txt
#
# syntax
# pygmentize -S <style> -f <formatter> [-a <arg>] [-O <options>] [-P <option=value>]
# (pygmentize documentation is pretty scattered and confusing, but the "-a" will add other classes
# to the output)

PYGMENTS_STYLES := $(shell python3 -c "from pygments.styles import get_all_styles; print(\"\n\".join(list(get_all_styles())))")
ROUGE_STYLES := base16 bw colorful github gruvbox igorpro magritte molokai monokai monokai pastie thankful_eyes tulip

# a recursively-expanding variable, so that its value contains an actual function call to be
# re-expanded under the control of foreach
pygmentize_gen_html = pygmentize -S $(style) -f html -a .highlight-$(style) > stylesheets/$(style).css;
rouge_gen_html = rougify style $(style) | sed -e 's/.highlight/.highlight-$(style)/' > stylesheets/$(style).css;

all: rouge pygments

pygments:
	$(foreach style, $(PYGMENTS_STYLES), $(pygmentize_gen_html))

rouge:
	$(foreach style, $(ROUGE_STYLES), $(rouge_gen_html))

styles:
	echo $(STYLES)

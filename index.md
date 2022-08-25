---
layout: page
title: "pygments-css by numist"
description: "CSS files derived from Pygments' built-in styles."
styles:
  - default
  - emacs
  - friendly
  - friendly_grayscale
  - colorful
  - autumn
  - murphy
  - manni
  - material
  - monokai
  - perldoc
  - pastie
  - borland
  - trac
  - native
  - fruity
  - bw
  - vim
  - vs
  - tango
  - rrt
  - xcode
  - igor
  - paraiso-light
  - paraiso-dark
  - lovelace
  - algol
  - algol_nu
  - arduino
  - rainbow_dash
  - abap
  - solarized-dark
  - solarized-light
  - sas
  - staroffice
  - stata
  - stata-light
  - stata-dark
  - inkpot
  - zenburn
  - gruvbox-dark
  - gruvbox-light
  - dracula
  - one-dark
  - lilypond
  - nord
  - nord-darker
  - github-dark
---

CSS files derived from Pygments' built-in styles.

[Pygments](http://pygments.org) is a Python-based code highlighting tool that comes with a set of builtin [styles](http://dev.pocoo.org/projects/pygments/browser/pygments/styles) (not css files) for code highlighting. You could [generate CSS files for these themes at the command line](https://github.com/numist/pygments-css/blob/master/makefile), or just click your favourite from the gallery below:

<style>
  .style-gallery {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-around;
  }
  h2 {
      margin-top: 2em;
  }
  .style-gallery h3 {
      margin-bottom: 0.1em;
  }
  .style-gallery pre {
      background-color: inherit;
  }
</style>

<div class="style-gallery">

{% for style in page.styles %}

<style>
  {% include_relative stylesheets/{{ style }}.css %}
</style>

<div>
<h3 id="{{ style }}"><a href="https://github.com/numist/pygments-css/blob/master/{{ style }}.css">{{ style }}</a></h3>

<div class="highlight-{{ style }}"><pre class="highlight-{{ style }}"><code><span class="kn">from</span> <span class="nn">typing</span> <span class="kn">import</span> <span class="n">Iterator</span>

<span class="c1"># This is an example
</span><span class="k">class</span> <span class="nc">Math</span><span class="p">:</span>
    <span class="o">@</span><span class="nb">staticmethod</span>
    <span class="k">def</span> <span class="nf">fib</span><span class="p">(</span><span class="n">n</span><span class="p">:</span> <span class="nb">int</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="n">Iterator</span><span class="p">[</span><span class="nb">int</span><span class="p">]:</span>
        <span class="s">""" Fibonacci series up to n """</span>
        <span class="n">a</span><span class="p">,</span> <span class="n">b</span> <span class="o">=</span> <span class="mi">0</span><span class="p">,</span> <span class="mi">1</span>
        <span class="k">while</span> <span class="n">a</span> <span class="o">&lt;</span> <span class="n">n</span><span class="p">:</span>
            <span class="k">yield</span> <span class="n">a</span>
            <span class="n">a</span><span class="p">,</span> <span class="n">b</span> <span class="o">=</span> <span class="n">b</span><span class="p">,</span> <span class="n">a</span> <span class="o">+</span> <span class="n">b</span>

<span class="n">result</span> <span class="o">=</span> <span class="nb">sum</span><span class="p">(</span><span class="n">Math</span><span class="p">.</span><span class="n">fib</span><span class="p">(</span><span class="mi">42</span><span class="p">))</span>
<span class="k">print</span><span class="p">(</span><span class="s">"The answer is {}"</span><span class="p">.</span><span class="nb">format</span><span class="p">(</span><span class="n">result</span><span class="p">))</span>
</code></pre></div>

</div>

{% endfor %}
    
</div>

# Overview

## Motivation

I developed this package as a general purpose tool for running
[`Literate.jl`](https://github.com/fredrikekre/Literate.jl) on collections of
files to generate Markdown (and, optionally, Jupyter notebooks). This tool is
primarily meant to be used in conjunction with static site generators. It
transforms Julia files into Markdown which can then be translated by any number
of static site tools into HTML to be published.

Much, if not all, of this could be done using
[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) directly. But in
cases where one wants to publish via _other_ tools, this makes the generation of
the Markdown quite easy. Example use cases include:

- Generating a `README.md` for a `git` repository directly from Julia code.
- Generating Markdown to inject into a [Jekyll](https://jekyllrb.com/) site.
- Generating Markdown for use with [`retype`](https://retype.com/)
- Generating Markdown for use with [`slidev`](https://sli.dev)
- Use with any other static site generator that accepts Markdown

**NB** These instructions assume you are using Julia v1.12 which, at this time,
has not yet been released. So until Julia v1.12 is released, you'll need to
use `juliaup` to first include the nightly builds with `juliaup add nightly`
and then when you run `julia`, invoke it with `julia +nightly`.

Also note...`Runlit` must be installed in your projects environment (whatever
that is) along with any other dependencies you might have.

## CLI Arguments

Running `julia -m Runlit -h` by itself will give you more information about command
line options. Current options are:

```
optional arguments:
  -f, --force          force updating of all input files
  -c, --code           show code only, do not execute
  --notebook           genereate notebook files as well
  -e, --ext EXT        file extension associated with input files
                       (default: ".jl")
  -i, --input INPUT    directory to search for input files
  -o, --output OUTPUT  directory where output files should be written
  -h, --help           show this help message and exit
```

## Guides

Here are some quick notes on how to start using `Runlit` with the
[`retype`](https://retype.com/) and [Slidev](https://sli.dev/) (both of which I
highly recommend).

As a general note, `Runlit` is designed to work with static site generators that
take Markdown as their input. So the general process here is going to involve:

1. Writing Julia code which `Runlit` will convert into Markdown
2. Running a static site generator that transforms the Markdown into HTML
3. Publishing the HTML somewhere.

This means that there will ultimately be _three_ different directories involved.
One to hold the Julia source code, one to hold the Markdown source code and one
to hold the HTML.

### Retype

#### Installation

For `retype`, you'll need to install `retype` (see
[here](https://retype.com/guides/getting-started/) on how to do that).
Everything discussed here can be found in the `examples/retype` directory. In
fact, you can just go to that directory and type `julia -m Runlit -i src -o
markdown` to generate the Markdown for it.

#### Project Initialization

Then you'll need to figure out how you want to organize your site content. There
are many configuration options for `retype`, but my suggestion is to create
a new Julia project, _e.g.,_

```
$ julia -e 'using Pkg; Pkg.generate("<ProjectName>")'
```

But however you choose to initialize your directory (it doesn't have to be a
Julia project at all), I suggest the following directory structure:

- `src` to hold your Julia source code
- `markdown` - to hold the generated Markdown
- `site` - to hold the generate site source code

You'll want to create these directories but most likely you'll want to put
`markdown` and `site` in your `.gitignore` file since they will contain
generated files not source files. You may want to version control the
`markdown` directory if your CI/CD pipeline (that publishes the site) isn't
Julia aware. This way you won't need Julia at all in your CI/CD environment.

For this configuration, the following `retype.yml` configuration file will
suffice and should be placed in the projects root directory:

```yaml
input: markdown
output: site
url: example.com # Add your website here
branding:
  title: Julia + Retype
  label: Docs
links:
  - text: Getting Started
    link: https://retype.com/guides/getting-started/
footer:
  copyright: "&copy; Copyright . All rights reserved."
```

If your Julia code uses any third party libraries, be sure to add them to the
`Project.toml` file (or, even better, press `]` in the `julia` REPL and use the
`pkg>` prompt to `add` them, _e.g.,_ `pkg> add Plots`).

**Please note** if you do depend on third party libraries (and, therefore, you
have your own `Project.toml` file distinct from the global Julia environments),
you need to be sure to add `Runlit` to your `Project.toml` as well.

#### Site Generation

At this point, if you have `Runlit` installed in your Julia environment, you can
just run `julia -m Runlit -i src -o markdown`. That will convert the Julia code
to Markdown. You could then run `retype build` to then transform the Markdown
to HTML. However, you could also do this:

```
$ julia -m Runlit -i src -o markdown -e 'retype build'
```

This command will convert your Julia to markdown and _then_ run the command
`retype build` which will regenerate the HTML. So this represents the complete
Julia -> HTML processing step (potentially useful in CI/CD pipelines, for
example).

#### Previewing

It is quite common to want to preview the results as you document. You can do
this a number of different ways. The first thing to know about is the `--watch`
(or `-w` for short) flag which will keep `Runlit` running and regenerating
Markdown whenever there is a change in your source directory, _e.g._,

```
$ julia -m Runlit -i src -o markdown -w
```

You can combine this with the `-e` flag as follows:

```
$ julia -m Runlit -i src -o markdown -w -e 'retype build'
```

The you can keep a browser open to the generated HTML and just hit refresh to
see the latest version. But an alternative is to simple run `Runlit` _without_
the `-e` flag and, in a separate shell, run `retype start`. This has a number
of benefits:

1. The `retype` process never shuts down so it responds much quicker to changes
   (because it won't regenerate the whole site, just update the files that
   changed).
2. It will open the browser for you.
3. It runs its own server that will cause the page to automatically reload
   whenever the HTML code is updated (so you don't have to keep reloading
   manually)

#### Front Matter

Many static site generators use "front-matter" (YAML metadata included at the
start of the Markdown code) to guide site generation. This is not an issue
for Literate.jl, just include a block like this at the top of your Julia file:

```
# ---
# label: Page Title
# ---
```

### Slidev

####

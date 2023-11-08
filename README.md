# Overview

## Motivation

I developed this package as a general purpose tool for running
[`Literate.jl`](https://github.com/fredrikekre/Literate.jl) on collections of
files to generate Markdown (and, optionally, Jupyter notebooks).  This tool is
primarily meant to be used in conjunction with static site generators.  It
transforms Julia files into Markdown which can then be translated by any number
of static site tools into HTML to be published.

Much, if not all, of this could be done using
[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) directly.  But in
cases where one wants to publish via other tools, this makes the generation of
the Markdown quite easy. Example use cases include:
- Generating a `README.md` for a `git` repository directly from Julia code.
- Generating Markdown to inject into a [Jekyll](https://jekyllrb.com/) site.
- Generating Markdown for use with [`retype`](https://retype.com/)
- Use with any other static site generator that accepts Markdown

This package is meant to be used in conjunction with the [`jlrun`
utility](https://github.com/mtiller-jh/jlrun). With the `jlrun` script installed
and this, `Runlit`, package installed, you trigger Markdown processing in two
ways:

```
$ jlrun Runlit -i <input_dir> -o <output_dir>
```

This will make a single pass over `<input_dir>` and convert the files to
Markdown.  It will replicate the hierarchy of `<input_dir>` into the
`<output_dir>` directory (including figures).

Another way to invoke this tool is with:

```
$ jlrun Runlit/watch  -i <input_dir> -o <output_dir>
```

This does exactly the same thing as the previous command except that it then
waits for any changes in the input directory and upon seeing and `.jl` files
changed it _re-runs_ the processing, _ad infinitum_.

Running `jlrun Runlit -h` by itself will give you more information about command
line options.  Current options are:

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

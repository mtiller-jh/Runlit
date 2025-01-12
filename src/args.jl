using ArgParse

Base.@kwdef struct Options
    docs::String
    output::String
    force::Bool
    ext::String
    execute::Bool
    suppress::Bool
    cmd::String
    markdown::Bool
    notebook::Bool
    watch::Bool
end

function parse_commandline(args::Union{Vector{String},Nothing}=nothing)::Options
    s = ArgParseSettings()

    @add_arg_table s begin
        "--force", "-f"
        help = "force updating of all input files"
        action = :store_true
        "--code", "-c"
        help = "show code only, do not execute"
        action = :store_true
        "--execute", "-e"
        help = "shell command to run after generating markdown"
        arg_type = String
        default = ""
        "--notebook"
        help = "genereate notebook files as well"
        action = :store_true
        "--ext"
        help = "file extension associated with input files"
        arg_type = String
        default = ".jl"
        "--input", "-i"
        help = "directory to search for input files"
        required = true
        "--output", "-o"
        help = "directory where output files should be written"
        required = true
        "--watch", "-w"
        help = "watch for future changes"
        action = :store_true
        "--suppress", "-s"
        help = "suppress postprocesses of image references to be relative"
        action = :store_true
    end

    if isnothing(args)
        parsed = parse_args(s)
    else
        parsed = parse_args(args, s)
    end

    docs = joinpath(pwd(), parsed["input"])
    output = joinpath(pwd(), parsed["output"])
    force::Bool = parsed["force"]
    ext::String = parsed["ext"]
    notebook::Bool = parsed["notebook"]
    code::Bool = parsed["code"]
    cmd::String = parsed["execute"]
    watch::Bool = parsed["watch"]
    suppress::Bool = parsed["suppress"]

    Options(docs=docs, output=output, force=force, cmd=cmd, ext=ext, execute=!code, suppress=suppress, markdown=true, notebook=notebook, watch=watch)
end

export parse_commandline
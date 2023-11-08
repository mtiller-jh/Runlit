using ArgParse

Base.@kwdef struct Options
    docs::String
    output::String
    force::Bool
    ext::String
    execute::Bool
    markdown::Bool
    notebook::Bool
end

function parse_commandline()::Options
    s = ArgParseSettings()

    @add_arg_table s begin
        "--force", "-f"
            help = "force updating of all input files"
            action = :store_true
        "--code", "-c"
            help = "show code only, do not execute"
            action = :store_true
        "--notebook"
            help = "genereate notebook files as well"
            action = :store_true
        "--ext", "-e"
            help = "file extension associated with input files"
            default = ".jl"
        "--input", "-i"
            help = "directory to search for input files"
            required = true
        "--output", "-o"
            help = "directory where output files should be written"
            required = true
    end

    parsed = parse_args(s)

    docs = joinpath(pwd(),parsed["input"])
    output = joinpath(pwd(),parsed["output"])
    force::Bool = parsed["force"]
    ext::String = parsed["ext"]
    notebook::Bool = parsed["notebook"]
    code::Bool = parsed["code"]

    Options(docs=docs, output=output, force=force, ext=ext, execute=!code, markdown=!notebook, notebook=notebook)
end

export parse_commandline
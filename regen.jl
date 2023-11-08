using Pkg;
Pkg.activate("..");

using Literate
using Dates

root = pwd()

function process(dir::String, force::Bool="RG_ALL" in keys(ENV))
    cd(joinpath(root, dir))
    files = vcat(readdir("."))
    litfiles = filter(x -> endswith(x, ".lit"), files)

    # Run Literate to generate notebook and markdown
    for file in litfiles
        (base,) = splitext(file)

        nfile = base * ".ipynb"
        ns = stat(nfile)
        mfile = base * ".md"
        ms = stat(mfile)
        fs = stat(file)

        if fs.mtime > ms.mtime || force
            pat = "$(base)-[0-9]+\\.svg"
            print("Searching for image files that match the pattern: $(pat)")
            rexp = Regex(pat)
            images = filter(x -> occursin(rexp, x), files)

            # Remove existing image files
            for image in images
                println("Removing $(image)")
                rm(image)
            end

            println("Generating markdown for $(mfile) from $(file) since $(fs.mtime) > $(ms.mtime)")
            Literate.markdown(file, "."; flavor=Literate.CommonMarkFlavor(), execute=true)
        end
        if fs.mtime > ns.mtime || force
            println("Generating notebook for $(nfile) from $(file) since $(fs.mtime) > $(ns.mtime)")
            Literate.notebook(file, "."; execute=true)
        end
    end
end

process(".")
process("generating")

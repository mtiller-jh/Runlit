module Runlit

using Literate

function process(docs::String, output::String; ext=".jl", notebook::Bool=false, markdown::Bool=true, force::Bool=false, execute::Bool=true)
    # Walk the docs directory
    for (root, _, files) in walkdir(docs)
        subdir = relpath(root, docs)
        # Loop over all files found while walking
        for file in files
            if !endswith(file, ext)
                continue
            end

            # Stat the input file
            ifile = joinpath(root, file)
            fs = stat(ifile)

            # Get the base name of the .jl file
            (base,) = splitext(file)

            if markdown
                mfile = joinpath(output, subdir, "$(base).md")
                ms = stat(mfile)

                # If the input file is more recent than the regenerated file or we are forcing 
                # regeneration, run Literate.jl
                if fs.mtime > ms.mtime || force
                    # pat = "$(base)-[0-9]+\\.svg"
                    # print("Searching for image files that match the pattern: $(pat)")
                    # rexp = Regex(pat)
                    # images = filter(x -> occursin(rexp, x), files)

                    # # Remove existing image files
                    # for image in images
                    #     println("Removing $(image)")
                    #     rm(image)
                    # end

                    println("Generating markdown for $(mfile) from $(ifile) since $(fs.mtime) > $(ms.mtime)")
                    Literate.markdown(ifile, joinpath(output, subdir); flavor=Literate.CommonMarkFlavor(), execute=execute)
                end
            end

            if notebook
                # This will be the name of the notebook file
                mfile = joinpath(output, subdir, "$(base).ipynb")
                ns = stat(nfile)


                if fs.mtime > ns.mtime || force
                    println("Generating notebook for $(nfile) from $(file) since $(fs.mtime) > $(ns.mtime)")
                    Literate.notebook(ifile, "."; execute=true)
                end
            end
        end
    end
end

export process

end

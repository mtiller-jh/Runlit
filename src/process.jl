using Literate

function process(opts::Options)
    # Walk the docs directory
    for (root, _, files) in walkdir(opts.docs)
        subdir = relpath(root, opts.docs)
        # Loop over all files found while walking
        for file in files
            if !endswith(file, opts.ext)
                continue
            end

            # Stat the input file
            ifile = joinpath(root, file)
            fs = stat(ifile)

            # Get the base name of the .jl file
            (base,) = splitext(file)

            if opts.markdown
                mfile = joinpath(opts.output, subdir, "$(base).md")
                ms = stat(mfile)

                # If the input file is more recent than the regenerated file or we are forcing 
                # regeneration, run Literate.jl
                if fs.mtime > ms.mtime || opts.force
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
                    Literate.markdown(ifile, joinpath(opts.output, subdir); flavor=Literate.CommonMarkFlavor(), execute=opts.execute)
                end
            end

            if opts.notebook
                # This will be the name of the notebook file
                mfile = joinpath(opts.output, subdir, "$(base).ipynb")
                ns = stat(nfile)


                if fs.mtime > ns.mtime || opts.force
                    println("Generating notebook for $(nfile) from $(file) since $(fs.mtime) > $(ns.mtime)")
                    Literate.notebook(ifile, "."; execute=opts.execute)
                end
            end
        end
    end
end

export process

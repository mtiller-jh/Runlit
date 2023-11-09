using Runlit 
using Pkg 

opts = parse_commandline()
println(opts)

if !isnothing(opts.project)
    println("Activating environment at: $(opts.project)")
    Pkg.activate(opts.project)
    Pkg.instantiate()
end

process(opts)

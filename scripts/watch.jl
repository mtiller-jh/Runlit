using Runlit
using Pkg
import BetterFileWatching

opts = parse_commandline()
println(opts)

if !isnothing(opts.project)
    Pkg.activate(opts.project)
    Pkg.instantiate()
end

# Do an initial pass
process(opts)

while true
    println("Waiting for changes in $(opts.docs)")
    # Wait for a change and then check again (and again, and again)
    BetterFileWatching.watch_folder(opts.docs) do event
        for file in event.paths
            process(opts)
        end
    end
end

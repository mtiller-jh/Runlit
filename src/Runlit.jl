module Runlit

using Runlit
import BetterFileWatching

input_directory::String = ""

include("./args.jl")
include("./process.jl")

function (@main)(args::Vector{String})

    opts = parse_commandline(args)
    println(opts)

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
end

end

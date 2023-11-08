using Runlit 
import FileWatching

opts = parse_commandline()
println(opts)

# Do an initial pass
process(opts)
while true
    println("Waiting for changes in $(opts.docs)")
    # Wait for a change and then check again (and again, and again)
    (file, event) = FileWatching.watch_folder(opts.docs)
    if endswith(file, opts.ext)
        process(opts)
    end
end

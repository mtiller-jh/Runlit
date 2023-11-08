using Runlit 
# using Comonicon

docs = ARGS[1]
output = ARGS[2]
force = true
process(docs, output, force=force)
# @main function run(;docs::String,output::String,force::Bool=false)
#     println("Running Runlit")
#     println("docs = $(docs)")
#     println("output = $(output)")
#     process(docs, output, force=force)
# end

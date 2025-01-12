# # Julia + retype
#
# This is an ordinary Julia file.  In this case, we are using 
# `retype` and so this is the `README` for our site (the root
# document of the site.  The contents

# The comments in our Julia file are the markdown for the page.
# Any actual Julia expressions will get evaluated by Julia and 
# their results will be inlined into the HTML, _e.g.,_e

2 + 4

# Of course, the great thing about doing this with Julia is the fact that 
# this goes well beyond just text output, _e.g.,_e

using GraphRecipes
using Plots

const n = 15
const A = Float64[rand() < 0.5 ? 0 : rand() for i = 1:n, j = 1:n]
for i = 1:n
    A[i, 1:i-1] = A[1:i-1, i]
    A[i, i] = 0
end

graphplot(A,
    markersize=0.2,
    node_weights=1:n,
    markercolor=range(colorant"yellow", stop=colorant"red", length=n),
    names=1:n,
    fontsize=10,
    linecolor=:darkgrey
)

# Isn't that cool? 😎

# What if we want to have other pages rather than just this `README`?  Easy, just create another
# file and put some Julia code in there as well, like [this one](./other.jl).
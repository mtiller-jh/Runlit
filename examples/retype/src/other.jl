# ---
# label: Another Page
# ---
# # Other files

# See, we can have multiple Julia files.  Just be sure to add any `using` statements
# you need to *each* file.  Note, you can hide those `using` statements in the HTML
# by adding '#hide` at the end of (any) line.

using GraphRecipes #hide
using Plots #hide

# See how this plot appears even though the `using` isn't in the final HTML?

const n = 15
const A = Float64[rand() < 0.5 ? 0 : rand() for i = 1:n, j = 1:n]
for i = 1:n
    A[i, 1:i-1] = A[1:i-1, i]
    A[i, i] = 0
end

graphplot(A,
    node_weights=1:n,
    markercolor=:darkgray,
    dim=3,
    markersize=5,
    linecolor=:darkgrey,
    linealpha=0.5
)
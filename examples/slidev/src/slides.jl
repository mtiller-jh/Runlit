# ---
# theme: seriph
# background: https://cover.sli.dev
# title: Welcome to Slidev
# info: |
#   ## Slidev Starter Template
#   Presentation slides for developers.

#   Learn more at [Sli.dev](https://sli.dev)
# class: text-center
# drawings:
#   persist: false
# transition: slide-left
# mdc: true
# ---

# # Julia + Slidev

# Presentation slides for Julia developers

# ---

# # First Slide

# This is a sample Julia script.  In it we can do the normal Julia things
# like:

2 + 7

# ...and see the result.

# We can add a comment with `---` in it to break the slide.

# ---

# # Second Slide

# See?  This content is now on a new slide?

# ---

# # Third Slide 

# But, of course, things get more exciting when you add cool
# multimedia Julia content, like plots:

using GraphRecipes #hide
using Plots #hide
const n = 15 #hide
const A = Float64[rand() < 0.5 ? 0 : rand() for i = 1:n, j = 1:n] #hide
for i = 1:n #hide
    A[i, 1:i-1] = A[1:i-1, i] #hide
    A[i, i] = 0 #hide
end #hide
graphplot(A, #hide
    markersize=0.2, #hide
    node_weights=1:n, #hide
    markercolor=range(colorant"yellow", stop=colorant"red", length=n), #hide
    names=1:n, #hide
    fontsize=10, #hide
    linecolor=:darkgrey #hide
) #hide


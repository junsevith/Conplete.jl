module Conplete

using Graphs

export SAT3
export VertexCover
include("problems.jl")


include("VertexCover.jl")

export solve
"""
Solve problem with JuMP using given solver
"""
function solve
end

end

module Conplete

using Graphs
using SparseArrays

abstract type Problem end

abstract type UnpackData end

abstract type Solution end


include("SAT3.jl")
include("VertexCover.jl")
include("Hamiltonian.jl")
include("unpack.jl")

# abstract types
export Problem
export UnpackData
export Solution

# function interfaces
export solve
export validate
export unpack

# concrete types
export SAT3
export SAT3Solution

export VertexCover
export VertexCoverSolution

export HamiltonianCircuit
export HamiltonianSolution


"""
Solve problem with JuMP using given solver
"""
function solve end

end
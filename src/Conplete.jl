module Conplete

using Graphs

abstract type NPProblem end

abstract type TransformationRecord end

abstract type NPSolution end

include("problems/CnfSAT.jl")
include("problems/SAT3.jl")
include("problems/BinPacking.jl")
include("problems/Clique.jl")
include("problems/Hamiltonian.jl")
include("problems/HittingSet.jl")
include("problems/SubsetSum.jl")
include("problems/Partition.jl")
include("problems/TravellingSalesman.jl")
include("problems/VertexCover.jl")
include("problems/Knapsack.jl")

include("unpack.jl")
include("reductionGraph.jl")
include("chain.jl")
include("show.jl")

# abstract types
export NPProblem
export TransformationRecord
export NPSolution

# problem Graph

export add_problem
export add_transformation

# function interfaces
export solve
export validate
export extract
export shortest_chain
export chain_transform
export transform

# concrete types
export SAT3
export SAT3Solution

export VertexCover
export VertexCoverSolution

export HamiltonianCycle
export HamiltonianCycleSolution

export SubsetSum

export Partition

export TravellingSalesman

export Clique

export HittingSet

export Knapsack

"""
Solve problem with JuMP using given solver
"""
function solve end

end
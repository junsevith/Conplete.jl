module Conplete

using Graphs

abstract type NPProblem end

abstract type NPSolution end

include("problems/CnfSAT.jl")
include("problems/SAT3.jl")
include("problems/BinPacking.jl")
include("problems/Clique.jl")
include("problems/Hamiltonian.jl")
include("problems/HittingSet.jl")
include("problems/SubsetSum.jl")
include("problems/Partition.jl")
include("problems/VertexCover.jl")
include("problems/Knapsack.jl")
include("problems/UndirectedHamiltonian.jl")
include("problems/TSP.jl")

include("extract.jl")
include("reductionGraph.jl")
include("transform.jl")
include("show.jl")
include("construct.jl")

# abstract types
export NPProblem
export TransformationRecord
export NPSolution

# problem Graph

export add_problem
export add_transformation
export problems
export solutions

# function interfaces
export solve
export validate
export extract
export shortest_chain
export chain_transform
export transform
export construct

# concrete types
export CNFSAT
export CNFSATSolution

export SAT3
export SAT3Solution

export VertexCover
export VertexCoverSolution

export DirHamCycle
export DirHamCycleSolution

export HamCycle
export HamCycleSolution

export SubsetSum
export SubsetSumSolution

export Partition

export TSP
export TSPSolution

export Clique
export CliqueSolution

export HittingSet

export Knapsack

"""
    solve(solver, problem) -> solution
Solve problem with JuMP using given solver
JuMP is required to be added for methos to appear
"""
function solve end

function validate(::Nothing, ::NPProblem)
    return false
end

function extract(::Nothing, ::NPProblem)
    return nothing
end

function construct(::DataType, ::Nothing, ::NPProblem)
    return nothing
end

end


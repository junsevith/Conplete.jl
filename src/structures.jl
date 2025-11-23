struct CNFSAT <: NPProblem
    variable_count::Int
    clauses::Vector{Vector{Int}}
end

struct CNFSATSolution <: NPSolution
    evaluation::BitVector
end

struct SAT3 <: NPProblem
    variable_count::Int
    clauses::Matrix{Int}
end

struct SAT3Solution <: NPSolution
    evaluation::BitVector
end

struct Clique <: NPProblem
    graph::SimpleGraph
    size::Int
end

struct CliqueSolution{S<:AbstractSet{Int}} <: NPSolution
    clique::S
end

struct VertexCover <: NPProblem
    graph::SimpleGraph
    size::Int
end

struct VertexCoverSolution{S<:AbstractSet{Int}} <: NPSolution
    cover::S
end

struct DirHamCycle <: NPProblem
    graph::SimpleDiGraph
end

"""
Solution to a Hamiltonian-Cycle problem containing cycle in following format:

an Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle

"""
struct DirHamCycleSolution <: NPSolution
    cycle::Vector{Int}
end

struct HamCycle <: NPProblem
    graph::SimpleGraph
end

"""
Solution to a Hamiltonian-Cycle problem containing cycle in following format:

an Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle

"""
struct HamCycleSolution <: NPSolution
    cycle::Vector{Int}
end

struct TSP <: NPProblem
    weights::Matrix{Int}
    length::Int
end

"""
Solution to a TravellingSalesman problem containing cycle in following format:

an Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle

"""
struct TSPSolution <: NPSolution
    cycle::Vector{Int}
end

struct SubsetSum{T<:Integer} <: NPProblem
    elements::Vector{T}
    sum::T
end

"""
Solution to a Subset Sum problem containing a set of indices of selected elements

"""
struct SubsetSumSolution{S<:AbstractSet{Int}} <: NPSolution
    subset::S
end

struct HittingSet{S<:AbstractSet{Int}} <: NPProblem
    universe_size::Int
    sets::Vector{S}
    size::Int
end

struct HittingSetSolution{S<:AbstractSet{Int}} <: NPSolution
    hitting_set::S
end

struct Partition{T<:Integer} <: NPProblem
    elements::Vector{T}
end

struct PartitionSolution{S<:AbstractSet{Int}} <: NPSolution
    subset::S
end

struct BinPacking{T<:Integer} <: NPProblem
    elements::Vector{T}
    bins::Int
    bin_size::T
end

struct BinPackingSolution <: NPSolution
    assignment::Vector{Int}
end

struct Knapsack{T<:Integer} <: NPProblem
    weights::Vector{T}
    values::Vector{T}
    max_weight::T
    min_value::T
end

"""
Solution to a Subset Sum problem containing a set of indices of selected elements

"""
struct KnapsackSolution{S<:AbstractSet{Int}} <: NPSolution
    subset::S
end
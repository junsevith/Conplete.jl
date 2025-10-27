struct CNFSAT <: NPProblem
    variable_count::UInt
    clauses::Vector{Vector{Int}}
end

struct CNFSATSolution <: NPSolution
    evaluation::BitVector
end

struct SAT3 <: NPProblem
    variable_count::UInt
    clauses::Matrix{Int}
end

struct SAT3Solution <: NPSolution
    evaluation::BitVector
end

struct Clique <: NPProblem
    graph::SimpleGraph
    size::UInt
end

struct CliqueSolution <: NPSolution
    clique::Set{UInt}
end

struct VertexCover <: NPProblem
    graph::SimpleGraph
    size::UInt
end

struct VertexCoverSolution <: NPSolution
    cover::Set{UInt}
end

struct DirHamCycle <: NPProblem
    graph::SimpleDiGraph{UInt}
end

"""
Solution to a Hamiltonian-Cycle problem containing cycle in following format:

an Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle

"""
struct DirHamCycleSolution <: NPSolution
    cycle::Vector{UInt}
end

struct HamCycle <: NPProblem
    graph::SimpleGraph{UInt}
end

"""
Solution to a Hamiltonian-Cycle problem containing cycle in following format:

an Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle

"""
struct HamCycleSolution <: NPSolution
    cycle::Vector{UInt}
end

struct TSP <: NPProblem
    weights::Matrix{Int}
    length::UInt
end

"""
Solution to a TravellingSalesman problem containing cycle in following format:

an Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle

"""
struct TSPSolution <: NPSolution
    cycle::Vector{UInt}
end

struct SubsetSum{T<:Integer} <: NPProblem
    set::Vector{T}
    sum::BigInt
end

"""
Solution to a Subset Sum problem containing a set of indices of selected elements

"""
struct SubsetSumSolution{S<:AbstractSet{Int}} <: NPSolution
    subset::S
end

struct HittingSet{T,U<:AbstractSet{T},S<:AbstractSet{T}} <: NPProblem
    universe::U
    sets::Vector{S}
    size::UInt
end

struct HittingSetSolution{T,S<:AbstractSet{T}} <: NPSolution
    hitting_set::S
end
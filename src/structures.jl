
"""
Instance of a Satisfiability problem in Conjunctive normal form.

Variables are denoted by integers from 1 to `variable_count`, negations of variables are denoted by corresponding negative integers.

# Fields
- `variable_count` : Number of different variables present in clauses
- `clauses` : clauses denoted as a vector of clause vectors
"""
struct CNFSAT <: NPProblem
    variable_count::Int
    clauses::Vector{Vector{Int}}
end

"""
Solution to a `CNFSAT` problem

# Fields
- `evaluation` : BitVector denoting evaluation of each variable
"""
struct CNFSATSolution <: NPSolution
    evaluation::BitVector
end

"""
Instance of a 3-SAT problem.

Variables are denoted by integers from 1 to `variable_count`, negations of variables are denoted by corresponding negative integers.

# Fields
- `variable_count` : Number of different variables present in clauses
- `clauses` : clauses denoted as matrix of size: 3 × m
"""
struct SAT3 <: NPProblem
    variable_count::Int
    clauses::Matrix{Int}
end

"""
Solution to a `SAT3` problem

# Fields
- `evaluation` : BitVector denoting evaluation of each variable
"""
struct SAT3Solution <: NPSolution
    evaluation::BitVector
end

"""
Instance of a Clique problem.

# Fields
- `graph` : Undirected graph in which we seek a clique
- `size` : minimal size of a clique 
"""
struct Clique <: NPProblem
    graph::SimpleGraph
    size::Int
end

"""
Solution to a `Clique` problem

# Fields
- `clique` : A set containing integers, corresponding to vertices belonging to clique
"""
struct CliqueSolution{S<:AbstractSet{Int}} <: NPSolution
    clique::S
end

"""
Instance of a Vertex Cover problem.

# Fields
- `graph` : Undirected graph in which we seek a vertex cover
- `size` : minimal size of a vertex cover 
"""
struct VertexCover <: NPProblem
    graph::SimpleGraph
    size::Int
end

"""
Solution to a `VertexCover` problem

# Fields
- `clique` : A generic set containing integers, corresponding to vertices belonging to vertex cover
"""
struct VertexCoverSolution{S<:AbstractSet{Int}} <: NPSolution
    cover::S
end


"""
Instance of a Hamiltonian Cycle problem in a directed graph.

# Fields
- `graph` : Directed graph in which we seek a Hamiltonian Cycle
"""
struct DirHamCycle <: NPProblem
    graph::SimpleDiGraph
end

"""
Solution to a `DirHamCycle` problem

# Fields
- `cycle` : Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle

"""
struct DirHamCycleSolution <: NPSolution
    cycle::Vector{Int}
end

"""
Instance of a Hamiltonian Cycle problem in a undirected graph.

# Fields
- `graph` : Undirected graph in which we seek a Hamiltonian Cycle
"""
struct HamCycle <: NPProblem
    graph::SimpleGraph
end

"""
Solution to a `HamCycle` problem

# Fields
- `cycle` : Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle
"""
struct HamCycleSolution <: NPSolution
    cycle::Vector{Int}
end

"""
Instance of a Travelling Salesman problem

# Fields
- `weights` : weights of edges in a full undirected graph
- `length` : maximal length of a cycle
"""
struct TSP <: NPProblem
    weights::Matrix{Int}
    length::Int
end

"""
Solution to a `TSP` problem

# Fields
- `cycle` : Vector of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle
"""
struct TSPSolution <: NPSolution
    cycle::Vector{Int}
end

"""
Instance of a Subset Sum problem

It utilizes generic integers, and can be constructed with any type which is a child of `Integer` abstract type

# Fields
- `elements` : vector of integers of which we seek a subset
- `sum` : target sum
"""
struct SubsetSum{T<:Integer} <: NPProblem
    elements::Vector{T}
    sum::T
end

"""
Solution to a `SubsetSum` problem

# Fields
- `subset` : generic set of indices corresponding to elements that are present in the subset
"""
struct SubsetSumSolution{S<:AbstractSet{Int}} <: NPSolution
    subset::S
end

"""
Instance of a Hitting Set problem

Set elements are denoted by the integers from 1 to `universe_size`

# Fields
- `universe_size` : number of different elements that can be present in sets
- `sets` : vector of sets, in which we seek a Hitting Set
- `size` : maximal size of a hitting set
"""
struct HittingSet{S<:AbstractSet{Int}} <: NPProblem
    universe_size::Int
    sets::Vector{S}
    size::Int
end

"""
Solution to a `HittingSet` problem

# Fields
- `subset` : generic set of elements contained in hitting set
"""
struct HittingSetSolution{S<:AbstractSet{Int}} <: NPSolution
    hitting_set::S
end

"""
Instance of a Partition problem

It utilizes generic integers, and can be constructed with any type which is a child of `Integer` abstract type

# Fields
- `elements` : vector of integers of which we seek a partition
"""
struct Partition{T<:Integer} <: NPProblem
    elements::Vector{T}
end

"""
Solution to a `Partition` problem

# Fields
- `subset` : generic set of indices corresponding to elements that are present in one part of the partition
"""
struct PartitionSolution{S<:AbstractSet{Int}} <: NPSolution
    subset::S
end

"""
Instance of a Bin Packing problem

It utilizes generic integers, and can be constructed with any type which is a child of `Integer` abstract type

# Fields
- `elements` : vector of integers of which we seek a packing
- `bins` : number of available bins 
- `bin_size` : size of a single bin
"""
struct BinPacking{T<:Integer} <: NPProblem
    elements::Vector{T}
    bins::Int
    bin_size::T
end

"""
Solution to a `BinPacking` problem

`assigment[x] = y` denotes assigment of element `x` to a bin `y` 

# Fields
- `assigment` : vector denoting assigment of a element to a bin
"""
struct BinPackingSolution <: NPSolution
    assignment::Vector{Int}
end

"""
Instance of a Knapsack problem

It utilizes generic integers, and can be constructed with any type which is a child of `Integer` abstract type

# Fields
- `elements` : vector of integers denoting element size
- `elements` : vector of integers denoting element value
- `size` : size of a knapsack (maximal sum of elements)
- `min_value` : minimal value sum of elements in knapsack
"""
struct Knapsack{S<:Integer,V<:Integer} <: NPProblem
    elements::Vector{S}
    values::Vector{V}
    size::S
    min_value::V
end

"""
Solution to a `Knapsack` problem

# Fields
- `subset` : generic set of indices corresponding to elements that are included in Knapsack
"""
struct KnapsackSolution{S<:AbstractSet{Int}} <: NPSolution
    subset::S
end
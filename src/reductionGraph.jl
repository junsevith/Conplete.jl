using Bijections

global problems = Bijection(
    CnfSAT => 1,
    SAT3 => 2,
    HamiltonianCycle => 3,
    VertexCover => 4,
    SubsetSum => 5,
    Clique => 6,
    Partition => 7,
    BinPacking => 8,
    HittingSet => 9,
    TravellingSalesman => 10,
    Knapsack => 11,
)

global solutions = Bijection(
    SAT3 => SAT3Solution,
    HamiltonianCycle => HamiltonianCycleSolution,
    VertexCover => VertexCoverSolution
)

global problemGraph = let
    local g = SimpleDiGraph(11)

    add_edge!(g, 1, 2)

    add_edge!(g, 2, 3)
    add_edge!(g, 2, 4)
    add_edge!(g, 2, 5)

    add_edge!(g, 3, 10)

    add_edge!(g, 4, 9)

    add_edge!(g, 5, 7)

    add_edge!(g, 6, 4)

    add_edge!(g, 7, 8)
    add_edge!(g, 7, 11)
    g
end

"""
    add_problem(new::Type{N}) where N<:NPProblem

adsadasdsadasd
"""
function add_problem(new::Type{N}) where N<:NPProblem
    add_vertex!(problemGraph)
    problems[new] = nv(problemGraph)
end

"""
    add_transformation(new::Type{N}, parent::Type{P}) where {N<:NPProblem,P<:NPProblem}


asdasdasdas
"""
function add_transformation(new::Type{N}, parent::Type{P}) where {N<:NPProblem,P<:NPProblem}
    met = methods(new, [parent])

    if length(met) == 0 || (length(met) == 1 && met[1].sig == Tuple{Type{new},Any})
        throw(MethodError(new, Tuple{parent}))
    end

    add_edge!(problemGraph, problems[parent], problems[new])
end
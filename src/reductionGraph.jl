using Bijections

global problems = Bijection{Type{<:NPProblem},UInt}(
    CNFSAT => 1,
    SAT3 => 2,
    DirHamCycle => 3,
    VertexCover => 4,
    SubsetSum => 5,
    Clique => 6,
    Partition => 7,
    BinPacking => 8,
    HittingSet => 9,
    TSP => 10,
    Knapsack => 11,
    HamCycle => 12,
)

global solutions = Bijection{Type{<:NPProblem},Type{<:NPSolution}}(
    CNFSAT => CNFSATSolution,
    SAT3 => SAT3Solution,
    DirHamCycle => DirHamCycleSolution,
    VertexCover => VertexCoverSolution,
    SubsetSum => SubsetSumSolution,
    Clique => CliqueSolution,
    HamCycle => HamCycleSolution,
    TSP => TSPSolution,
    HittingSet => HittingSetSolution
    )

global problemGraph = let
    local g = SimpleDiGraph(length(problems))

    add_edge!(g, 1, 2)

    add_edge!(g, 2, 3)
    add_edge!(g, 2, 4)
    add_edge!(g, 2, 5)

    # add_edge!(g, 3, 10)
    add_edge!(g, 3, 12)

    add_edge!(g, 4, 9)

    add_edge!(g, 5, 7)

    add_edge!(g, 6, 4)

    add_edge!(g, 7, 8)
    add_edge!(g, 7, 11)

    add_edge!(g, 12, 10)
    g
end

"""
    add_problem(instance_type, solution_type)

Add a custom NP complete problem to the transformation graph.
This makes it available for using `add_transformation`.
"""
function add_problem(inst::Type{<:NPProblem}, solution::Type{<:NPSolution})
    add_vertex!(problemGraph)
    solutions[inst] = solution
    problems[inst] = nv(problemGraph)

    return nothing
end

"""
    add_transformation(new, parent)

Add a transformation to the transformation graph, 
This makes it available for transformation using `transform` and `chain_transform` functions.
"""
function add_transformation(new::Type{<:NPProblem}, parent::Type{<:NPProblem})
    met = methods(transform, [parent, Type{new}])

    if length(met) == 0 || met[1].sig == Tuple{typeof(transform),NPProblem,Type{<:NPProblem}}
        throw(MethodError(transform, Tuple{parent,Type{new}}))
    end

    add_edge!(problemGraph, problems[parent], problems[new])

    return nothing
end
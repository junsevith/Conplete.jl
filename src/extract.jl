"""
    extract(solution, instance_chain) -> target_solution
From `solution` of the child problem extract the solution of the parent problem that was base for child problem when transformation was performed.

`instance_chain` contains all problem instances that were produced during chain transformation

Depth specifies how deep to extract when problem is a result of multiple transformations.
"""
extract(solution::NPSolution, chain::Vector{NPProblem}) = foldl(extract, Iterators.reverse(chain); init=solution)


# unpack(solution::DirHamCycleSolution, problem::DirHamCycle, depth::Int) = unpack(solution, problem.record, depth)
# unpack(solution::VertexCoverSolution, problem::VertexCover, depth::Int) = unpack(solution, problem.record, depth)


# """
#     extract(solution, problem, depth) -> target_solution
# From `solution` of the `problem` extract solution of the parent problem that was base for `problem` when transformation was performed.

# Depth specifies how deep to extract when `problem` is a result of multiple transformations.
# """
# extract(solution::NPSolution, problem::NPProblem, depth::Int=typemax(Int)) = extract(solution, getfield(problem, :record), depth)




"""
    extract(solution, transformation_data, depth) -> target_solution
From `solution` of the child problem extract the solution of the parent problem that was base for child problem when transformation was performed.

`transformation_data` contains information about transformations that resulted in child problem.

Depth specifies how deep to extract when problem is a result of multiple transformations.
"""
function extract(solution::NPSolution, reductionData::Array{TransformationRecord}, depth::UInt=typemax(UInt))
    current = solution
    for d in reductionData
        if depth == 0
            return current
        end

        current = extract(current, d)
        depth -= 1
    end

    return current
end

# unpack(solution::HamiltonianCycleSolution, problem::HamiltonianCycle, depth::UInt) = unpack(solution, problem.record, depth)
# unpack(solution::VertexCoverSolution, problem::VertexCover, depth::UInt) = unpack(solution, problem.record, depth)


"""
    extract(solution, problem, depth) -> target_solution
From `solution` of the `problem` extract solution of the parent problem that was base for `problem` when transformation was performed.

Depth specifies how deep to extract when `problem` is a result of multiple transformations.
"""
extract(solution::NPSolution, problem::NPProblem, depth::UInt=typemax(UInt)) = extract(solution, getfield(problem, :record), depth)




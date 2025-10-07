function extract(solution::NPSolution, reductionData::Array{TransformationRecord}, depth::UInt=typemax(UInt))
    current = solution
    for d in reductionData
        if depth == 0
            return current
        end

        current = extract(current, d)
    end

    return current
end

# unpack(solution::HamiltonianCycleSolution, problem::HamiltonianCycle, depth::UInt) = unpack(solution, problem.record, depth)
# unpack(solution::VertexCoverSolution, problem::VertexCover, depth::UInt) = unpack(solution, problem.record, depth)

extract(solution::NPSolution, problem::NPProblem, depth::UInt=typemax(UInt)) = extract(solution, getfield(problem, :record), depth)




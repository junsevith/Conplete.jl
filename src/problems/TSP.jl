function transform(parent::HamCycle, target::Type{TSP})
    return TSP(map!(x -> 1-x, Matrix(adjacency_matrix(parent.graph))), 0)
end

extract(sol::TSPSolution, parent::HamCycle) = HamCycleSolution(sol.cycle)

construct(target::Type{TSPSolution}, sol::HamCycleSolution, parent::HamCycle) = TSPSolution(sol.cycle)

function validate(sol::TSPSolution, problem::TSP)
    n = length(sol.cycle)

    if n != size(problem.weights, 1)
        return ErrorException("Invalid number of vertices in cycle")
    end

    if !all(x -> 0 < x <= n, sol.cycle)
        return ErrorException("Invalid vertex in cycle")
    end

    if !allunique(sol.cycle)
        return ErrorException("Vertex is traversed twice")
    end

    if problem.length > sum(i -> problem.weights[i...], enumerate(sol.cycle))
        return ErrorException("Cycle is too long")
    end

    return true

end
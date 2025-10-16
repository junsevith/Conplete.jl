struct Clique <: NPProblem
    graph::SimpleGraph
    size::UInt
end

struct CliqueSolution
    clique::Array{UInt}
end

function validate(solution::CliqueSolution, problem::Clique)
    sorted = sort(solution.clique)

    if length(solution.clique) > problem.size
        return false
    end

    for v in sorted
        neig = neighbors(problem.graph, v)
        sort!(neig)

        for i in eachindex(sorted)
            if neig[i] != sorted[i] && sorted[i] != v
                return false
            end
        end
    end

    return true
end
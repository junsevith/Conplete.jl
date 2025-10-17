struct Clique <: NPProblem
    graph::SimpleGraph
    size::UInt
end

struct CliqueSolution
    clique::Array{UInt}
end

function validate(solution::CliqueSolution, problem::Clique)
    # display(solution.clique)
    # display(problem.size)

    if length(solution.clique) > problem.size
        return ErrorException("Solution too large")
    end

    for f in solution.clique, s in solution.clique
        if f != s && !has_edge(problem.graph, f, s)
            return false
        end
    end

    return true
end

function transform(input::SAT3, target::Type{Clique})
    g = complete_graph(size(input.clauses, 1) * 3)

    pos = [[] for _ in 1:input.variable_count]
    neg = deepcopy(pos)

    vertices = 0

    for row in axes(input.clauses, 1)
        clause = [vertices += 1 for _ in 1:3]

        rem_edge!(g, clause[1], clause[2])
        rem_edge!(g, clause[2], clause[3])
        rem_edge!(g, clause[3], clause[1])

        for (i, vert) in enumerate(clause)
            var = input.clauses[row, i]

            if var > 0
                foreach(x -> rem_edge!(g, vert, x), neg[var])
                push!(pos[var], vert)
            else
                foreach(x -> rem_edge!(g, vert, x), pos[-var])
                push!(neg[-var], vert)
            end

        end
    end

    return Clique(g, size(input.clauses, 1))
end
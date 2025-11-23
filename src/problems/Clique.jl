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

    # we will start with complete graph and will start removing edges
    # each vertex correspons to element of clause
    g = complete_graph(size(input.clauses, 1) * 3)

    pos = [Int[] for _ in 1:input.variable_count]
    neg = deepcopy(pos)

    vertices = 0

    for row in axes(input.clauses, 1)
        clause = [vertices += 1 for _ in 1:3]

        # we remove edges between variables in the same clause
        rem_edge!(g, clause[1], clause[2])
        rem_edge!(g, clause[2], clause[3])
        rem_edge!(g, clause[3], clause[1])

        # we remove edges between positive and negative uses of variable
        for (i, vert) in enumerate(clause)
            var = input.clauses[row, i]

            if var > 0
                rem_edge!.(Ref(g), vert, neg[var])
                push!(pos[var], vert)
            else
                rem_edge!.(Ref(g), vert, pos[-var])
                push!(neg[-var], vert)
            end

        end
    end

    return Clique(g, size(input.clauses, 1))
end

function extract(solution::CliqueSolution, parent::SAT3)
    valuation = falses(parent.variable_count)
    done = Set{Int}()

    for v in solution.clique
        (r, c) = divrem(v - 1, 3)
        val = parent.clauses[r+1, c+1]

        if abs(val) in done
            continue
        else
            push!(done, abs(val))
        end

        if val > 0
            valuation[val] = true
        end


        if length(done) >= parent.variable_count
            break
        end
    end

    return SAT3Solution(valuation)
end

function construct(target::Type{CliqueSolution}, sol::SAT3Solution, parent::SAT3)

    clique = Set{Int}()
    sizehint!(clique, size(parent.clauses, 1))

    for clause in axes(parent.clauses, 1)
        for var in 1:3
            val = parent.clauses[clause, var]

            if (val > 0) == sol.evaluation[abs(val)]
                push!(clique, 3(clause - 1) + var)
                break
            end
        end
    end

    return CliqueSolution(clique)
end

function transform(parent::VertexCover, target::Type{Clique})
    return Clique(Graphs.complement(parent.graph), nv(parent.graph) - parent.size)
end

function extract(solution::CliqueSolution, instance::VertexCover)
    return VertexCoverSolution(setdiff(Set(1:nv(instance.graph)), solution.clique))
end

function construct(target::Type{CliqueSolution}, solution::VertexCoverSolution, parent::VertexCover)
    return CliqueSolution(setdiff(Set(1:nv(parent.graph)), solution.cover))
end
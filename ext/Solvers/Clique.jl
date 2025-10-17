function Conplete.solve(solver, problem::Clique)
    model = Model(solver)
    vert = vertices(problem.graph)

    edges = adjacency_matrix(problem.graph)

    # display(edges)

    set_silent(model)
    @variable(model, v[vertices(problem.graph)], Bin)

    for i in axes(edges, 1), j in axes(edges, 2)
        if i != j && edges[i,j] == 0
            @constraint(model, v[i] + v[j] <= 1)
        end
    end

    @constraint(model, sum(v) >= problem.size)

    @objective(model, Max, sum(v))

    # println(model)

    optimize!(model)

    # display(value(v))

    if is_solved_and_feasible(model)
        set = [i for (i, val) in enumerate(value(v)) if val > 0.5]
        return CliqueSolution(set)
    else
        return Nothing
    end
end
function Conplete.solve(solver, problem::Clique)
    model = Model(solver)
    vert = vertices(problem.graph)

    edges = adjacency_matrix(problem.graph)

    # display(edges)

    set_silent(model)
    @variable(model, v[vertices(problem.graph)], Bin)

    for i in vert
        @constraint(model, v[i] => {sum(v[j] * edges[i, j] for j in vert) == sum(v) - 1})
    end

    @constraint(model, sum(v) == problem.size)

    @objective(model, Min, 1)

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
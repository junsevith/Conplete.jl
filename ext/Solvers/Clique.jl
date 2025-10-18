function Conplete.solve(solver, problem::Clique)
    model = Model(solver)

    edges = adjacency_matrix(problem.graph)

    set_silent(model)
    @variable(model, v[vertices(problem.graph)], Bin)

    for i in axes(edges, 1), j in axes(edges, 2)
        if i != j && edges[i,j] == 0
            @constraint(model, v[i] + v[j] <= 1)
        end
    end

    @constraint(model, sum(v) >= problem.size)

    @objective(model, Max, sum(v))

    optimize!(model)

    if is_solved_and_feasible(model)
        set = [i for (i, val) in enumerate(value(v)) if val > 0.5]
        return CliqueSolution(set)
    else
        return nothing
    end
end
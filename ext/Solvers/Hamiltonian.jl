function Conplete.solve(solver, problem::HamiltonianCircuit)
    model = Model(solver)
    vert = vertices(problem.graph)

    edges = adjacency_matrix(problem.graph)

    display(edges)

    # set_silent(model)
    @variable(model, e[i=vert, j=vert] <= edges[i, j], Bin)

    for v in vert
        @constraint(model, sum(e[v, i] for i in vert) == 1)
        @constraint(model, sum(e[i, v] for i in vert) == 1)
    end

    @objective(model, Min, 1)

    # println(model)

    optimize!(model)
    # display(value(e))

    display(sum(value(e)))

    return is_solved_and_feasible(model)
end
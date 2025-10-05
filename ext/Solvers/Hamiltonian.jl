function Conplete.solve(solver, problem::HamiltonianCircuit)
    model = Model(solver)
    vert = vertices(problem.graph)

    edges = adjacency_matrix(problem.graph)

    # display(edges)

    set_silent(model)
    @variable(model, e[i=vert, j=vert] <= edges[i, j], Bin)

    for v in vert
        @constraint(model, sum(e[v, i] for i in vert) == 1)
        @constraint(model, sum(e[i, v] for i in vert) == 1)
    end

    for i in vert, j in vert
        @constraint(model, e[i,j] + e[j,i] <= 1)
    end

    @objective(model, Min, 1)

    # println(model)

    optimize!(model)

    # val = sparse(value(e))

    # display(val)

    # display(sum(value(e)))

    if is_solved_and_feasible(model)
        val = value(e)
        cycle = []
        for i in axes(val, 1), j in axes(val, 2)
            if val[i, j] > 0.5
                push!(cycle,(i,j))
            end
        end
        return HamiltonianSolution(cycle)
    else
        return Nothing
    end
end
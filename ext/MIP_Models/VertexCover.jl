function Conplete.solve(solver, problem::VertexCover)
    model = Model(solver)

    # set_optimizer_attribute(model, "msg_lev", 3)
    set_silent(model)
    @variable(model, v[1:nv(problem.graph)], Bin)

    for e in edges(problem.graph)
      @constraint(model, v[src(e)] + v[dst(e)] >= 1)
    end

    @constraint(model, sum(v) <= problem.size)

    @objective(model, Min, sum(v))

    optimize!(model)

    if is_solved_and_feasible(model)
      return VertexCoverSolution(Set(findall(x -> x > 0.5, value(v))))
    else
      return nothing
    end
end
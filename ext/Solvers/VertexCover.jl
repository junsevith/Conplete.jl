function Conplete.solve(solver, problem::VertexCover)
    model = Model(solver)

    set_silent(model)
    @variable(model, v[vertices(problem.graph)], Bin)

    for e in edges(problem.graph)
      @constraint(model, v[src(e)] + v[dst(e)] >= 1)
    end

    @constraint(model, sum(v) <= problem.size)

    @objective(model, Min, 1)

    # println(model)

    optimize!(model)

    # display(value(v))

    # display(sum(value(v)))

    if is_solved_and_feasible(model)
      set = Set()

      for (i,val) in enumerate(value(v))
        if val > 0.5
          push!(set, i)
        end
      end

      return VertexCoverSolution(set)
    else
      return Nothing
    end
end
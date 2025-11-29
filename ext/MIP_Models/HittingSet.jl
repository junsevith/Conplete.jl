function Conplete.solve(model::Model, inst::HittingSet)

    @variable(model, x[1:inst.universe_size], Bin)

    for s in inst.sets
        @constraint(model, sum(i -> x[i], s) >= 1)
    end

    @constraint(model, sum(x) <= inst.size)

    @objective(model, Min, sum(x))

    optimize!(model)

    return if is_solved_and_feasible(model)
        val = value.(x)
        HittingSetSolution(Set([i[1] for i in eachindex(val) if val[i] > 0.5]))
    else 
        nothing
    end

end
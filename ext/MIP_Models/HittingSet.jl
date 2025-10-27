function Conplete.solve(solver, inst::HittingSet)
    model = Model(solver)

    set_silent(model)
    @variable(model, x[inst.universe], Bin)

    for s in inst.sets
        @constraint(model, sum(i -> x[i], s) >= 1)
    end

    @objective(model, Min, sum(x))

    optimize!(model)

    return if is_solved_and_feasible(model)
        val = value.(x)
        HittingSetSolution(BitSet(findall([val[i] > 0.5 for i in eachindex(val)])))
    else 
        nothing
    end

end
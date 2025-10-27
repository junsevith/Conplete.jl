function Conplete.solve(solver, inst::SubsetSum)
    model = Model(solver)

    set_silent(model)
    @variable(model, x[eachindex(inst.set)], Bin)
    @constraint(model, sum(x .* inst.set) == inst.sum)
    @objective(model, Min, 1)

    optimize!(model)

    return if is_solved_and_feasible(model)
        SubsetSumSolution(BitSet(findall(value(x) .> 0.5)))
    else
        nothing
    end

end
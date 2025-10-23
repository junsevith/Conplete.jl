function Conplete.solve(solver, inst::SubsetSum)
    model = Model(solver)

    set_silent(model)
    @variable(model, x[eachindex(inst.set)], Bin)
    @constraint(model, sum(x .* inst.set) == inst.sum)
    @objective(model, Min, 1)

    optimize!(model)

    return SubsetSumSolution(BitArray(value(x)))

end
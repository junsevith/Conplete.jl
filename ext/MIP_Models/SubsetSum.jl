function Conplete.solve(solver, inst::SubsetSum)
    model = Model(solver)

    @variable(model, x[eachindex(inst.set)], Bin)
    @constraint(model, sum(x .* inst.set) == inst.sum)
    @objective(model, Min, 1)

    optimize!(model)

    return BitArray(value(x))

end
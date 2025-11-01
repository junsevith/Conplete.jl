function Conplete.solve(solver, inst::SubsetSum)
    model = Model(solver)

    set_silent(model)
    @variable(model, x[eachindex(inst.elements)], Bin)
    @constraint(model, sum(x .* inst.elements) == inst.sum)
    @objective(model, Min, 1)

    optimize!(model)

    return if is_solved_and_feasible(model)
        SubsetSumSolution(BitSet(findall(y -> y > 0.5, value(x))))
    else
        nothing
    end
end
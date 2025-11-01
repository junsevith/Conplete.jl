function Conplete.solve(solver, inst::Partition)
    model = Model(solver)

    set_silent(model)
    @variable(model, x[eachindex(inst.elements)], Bin)
    @constraint(model, sum(x .* inst.elements) == sum(.-(x .- 1) .* inst.elements))
    @objective(model, Min, 1)

    optimize!(model)

    return if is_solved_and_feasible(model)
        PartitionSolution(BitSet(findall(y -> y > 0.5, value(x))))
    else
        nothing
    end

end
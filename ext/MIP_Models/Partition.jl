function Conplete.solve(solver, inst::Partition)
    model = Model(solver)

    set_silent(model)
    @variable(model, x[eachindex(inst.set)], Bin)
    @constraint(model, sum(x .* inst.set) == sum(.-(x .- 1) .* inst.set))
    @objective(model, Min, 1)

    optimize!(model)

    return if is_solved_and_feasible(model)
        PartitionSolution(BitSet(findall(value(x) .> 0.5)))
    else
        nothing
    end

end
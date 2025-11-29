function Conplete.solve(model::Model, inst::Partition)

    @warn "This model provides accurate solutions only for small numbers due to float conversion"

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
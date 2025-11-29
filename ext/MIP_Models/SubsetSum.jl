function Conplete.solve(model::Model, inst::SubsetSum)

    @warn "This model provides accurate solutions only for small numbers due to float conversion"

    @variable(model, x[eachindex(inst.elements)], Bin)
    @constraint(model, sum(x .* inst.elements) == inst.sum)
    @objective(model, Min, sum(x))

    optimize!(model)

    # display(value(sum(x .* inst.elements)))
    # display(sum(round.(Int, value.(x)) .* inst.elements))
    # display(value.(x))

    return if is_solved_and_feasible(model)
        SubsetSumSolution(BitSet(findall(y -> y > 0.5, value(x))))
    else
        nothing
    end
end
function Conplete.solve(model::Model, inst::Knapsack)

    @warn "This model provides accurate solutions only for small numbers due to float conversion"

    @variable(model, x[eachindex(inst.elements)], Bin)
    @constraint(model, sum(x .* inst.elements) <= inst.size)
    @constraint(model, sum(x .* inst.values) >= inst.min_value)
    @objective(model, Max, sum(x .* inst.values))

    optimize!(model)

    return if is_solved_and_feasible(model)
        KnapsackSolution(BitSet(findall(y -> y > 0.5, value(x))))
    else
        nothing
    end

end
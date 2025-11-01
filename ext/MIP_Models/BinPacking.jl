function Conplete.solve(solver, inst::BinPacking)
    model = Model(solver)

    n = length(inst.elements)
    m = inst.bins

    set_silent(model)
    @variable(model, x[1:n, 1:m], Bin)
    @constraint(model, [e = 1:n], sum(x[e, :]) == 1)
    @constraint(model, [b = 1:m], sum(x[:, b] .* inst.elements) <= inst.bin_size)
    @objective(model, Min, 1)

    # println(model)

    optimize!(model)


    return if is_solved_and_feasible(model)
        BinPackingSolution(findfirst.(v -> v > 0.5, eachrow(value(x))))
    else
        nothing
    end

end
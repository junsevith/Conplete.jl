function Conplete.solve(solver, problem::CNFSAT)
    model = Model(solver)

    set_silent(model)
    @variable(model, x[1:problem.variable_count], Bin)
    rows = size(problem.clauses, 1)

    @constraint(model, [r = 1:rows], sum(v -> v > 0 ? x[v] : 1 - x[-v], problem.clauses[r]) >= 1)

    @objective(model, Min, 1)

    optimize!(model)

    if is_solved_and_feasible(model)
        return CNFSATSolution(value(x))
    else
        return nothing
    end
end
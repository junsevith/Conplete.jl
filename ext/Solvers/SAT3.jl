function Conplete.solve(solver, problem::SAT3)
    model = Model(solver)

    set_silent(model)
    @variable(model, x[0:problem.variable_count], Bin)
    rows = size(problem.clauses, 1)

    function translate(var)
      if var < 0
        return (1 - x[abs(var)])
      else
        x[var]
      end
    end

    @constraint(model, [r = 1:rows], translate(problem.clauses[r, 1]) + translate(problem.clauses[r, 2]) + translate(problem.clauses[r, 3]) >= 1)

    @objective(model, Min, 1)

    # println(model)

    optimize!(model)

    # display(value(x))

    return is_solved_and_feasible(model)
end
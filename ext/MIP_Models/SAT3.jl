function Conplete.solve(model::Model, problem::SAT3)

    @variable(model, x[1:problem.variable_count], Bin)
    rows = size(problem.clauses, 1)

    function translate(var::Int)
      if var < 0
        return (1 - x[abs(var)])
      else
        x[var]
      end
    end

    @constraint(model, [r = 1:rows], sum(translate, problem.clauses[r, 1:3]) >= 1)

    @objective(model, Min, 1)

    optimize!(model)

    if is_solved_and_feasible(model)
      return SAT3Solution(value(x))
    else
      return nothing
    end
end
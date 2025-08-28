module Solvers

using Conplete
using JuMP

function Conplete.solve(model, problem::SAT3)
    model = Model(model)
    @variable(model, x[0:problem.variable_count])
    return true
end

export solve_3sat

end
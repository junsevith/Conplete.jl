function solve_3sat(model ,problem::SAT3)
  model = Model(model)
  @variable(model, x[0:problem.variable_count] )
  return true
end

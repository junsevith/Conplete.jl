using Test
using JuMP
using Conplete
using Graphs

solver = try
  using CPLEX

  CPLEX.Optimizer
catch
  using HiGHS

  HiGHS.Optimizer
end

problem = SAT3("../test_data/uf20-91/uf20-01.cnf")

ham = HamiltonianCircuit(problem)

# @test solve(solver, ham)


display(problem)


model = Model(solver)
vert = vertices(ham.graph)

edges = adjacency_matrix(ham.graph)

# for i in axes(edges, 1)
#   for j in axes(edges, 2)
#     print(edges[i, j])
#     print(" ")
#   end
#   println()
# end

display(edges)

set_silent(model)
@variable(model, e[i=vert, j=vert] <= edges[i, j], Bin)

for v in vert
    @constraint(model, sum(e[v, i] for i in vert) == 1)
    @constraint(model, sum(e[i, v] for i in vert) == 1)
end

@objective(model, Min, 1)

# println(model)

optimize!(model)
display(value(e))

display(sum(value(e)))

@test is_solved_and_feasible(model)
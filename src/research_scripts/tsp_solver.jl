using Conplete, LHK

sat3 = SAT3("Conplete.jl/test_data/UF250.1065.100/uf250-01.cnf")

ham = transform(sat3, HamiltonianCycle)

edges = adjacency_matrix(ham.graph)

@time solve_tsp(Matrix(edges))
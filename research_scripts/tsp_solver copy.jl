using Conplete, Concorde, Graphs

sat3 = SAT3("test_data/uf20-91/uf20-01.cnf")

ham = transform(sat3, HamCycle)

edges = adjacency_matrix(ham.graph)

display(edges)

@time solve_tsp(Matrix(edges))
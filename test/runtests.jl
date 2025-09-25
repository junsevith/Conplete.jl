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

@testset "Solvers" begin
  # Write your tests here.
  print("Using solver: ")
  println(solver)

  @testset let
    problem = SAT3("../test_data/uf20-91/uf20-01.cnf")

    @test solve(solver, problem)

    vc = VertexCover(problem)

    @test solve(solver, vc)

    # ham = HamiltonianCircuit(problem)

  end

  @testset let

  end
end




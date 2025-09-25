using Test
using JuMP
using Conplete
using Graphs

include("solver.jl")

@testset "Solvers" begin
  # Write your tests here.

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




using Test
using JuMP, CPLEX
using Conplete
using Graphs

include("data.jl")

solver = CPLEX.Optimizer

@testset "Solvers" begin
  # Write your tests here.

  @testset let
    problem = SAT3(20, matrix)
    @test solve(solver, problem)

    vc = VertexCover(problem)

    @test solve(solver, vc)

    ham = HamiltonianCircuit(problem)

  end

  @testset let

  end
end




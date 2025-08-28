using Test
using JuMP, CPLEX
using Conplete

@testset "Conplete.jl" begin
  # Write your tests here.
  
end

@testset "3SAT" begin
  model = CPLEX.Optimizer
    matrix = [
      3 2 1
      2 -4 5
    ]
    @test solve(model, SAT3(5, matrix))
    
  end
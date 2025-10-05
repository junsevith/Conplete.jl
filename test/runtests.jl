using Test
using JuMP
using Conplete
using Graphs

Base.show(io::IO, x::T) where {T<:Union{UInt,UInt128,UInt64,UInt32,UInt16,UInt8}} = Base.print(io, x)

solver = try
  using CPLEX

  CPLEX.Optimizer
catch
  using HiGHS

  HiGHS.Optimizer
end

include("data.jl")

@testset "Solvers" begin
  # Write your tests here.
  print("Using solver: ")
  println(solver)

  @testset let
    problem = SAT3("../test_data/uf20-91/uf20-02.cnf")
    # problem = SAT3(matrix2)

    og_sol = solve(solver, problem)

    display(og_sol)

    @test !isnothing(og_sol)

    vc = VertexCover(problem)

    @test solve(solver, vc)


    ham = HamiltonianCircuit(problem)

    ham_sol = solve(solver, ham)

    @test !isnothing(ham_sol)

    # display(ham_sol)

    sat3_sol = unpack(ham_sol, ham)

    display(sat3_sol)

    @test validate(sat3_sol, problem)

    @test validate(og_sol, problem)

  end

end




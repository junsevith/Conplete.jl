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

    @test validate(og_sol, problem)

    #vertex cover
    vc = VertexCover(problem)

    vc_sol = solve(solver, vc)

    @test validate(vc_sol, vc)

    vc_sat = unpack(vc_sol, vc)

    @test validate(vc_sat, problem)


    #hamiltonian
    ham = HamiltonianCircuit(problem)

    ham_sol = solve(solver, ham)

    @test validate(ham_sol, ham)

    ham_sat = unpack(ham_sol, ham)

    @test validate(ham_sat, problem)

    display(og_sol)
    display(vc_sat)
    display(ham_sat)


  end

end




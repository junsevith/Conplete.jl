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

# @testset "Solvers" begin
#   # Write your tests here.
#   print("Using solver: ")
#   println(solver)

#   @testset let
#     problem = SAT3("../test_data/uf20-91/uf20-02.cnf")
#     # problem = SAT3(matrix2)

#     og_sol = solve(solver, problem)

#     @test validate(og_sol, problem)

#     #vertex cover
#     vc = VertexCover(problem)

#     vc_sol = solve(solver, vc)

#     @test validate(vc_sol, vc)

#     vc_sat = extract(vc_sol, vc)

#     @test validate(vc_sat, problem)


#     #hamiltonian
#     ham = HamiltonianCycle(problem)

#     ham_sol = solve(solver, ham)

#     @test validate(ham_sol, ham)

#     ham_sat = extract(ham_sol, ham)

#     @test validate(ham_sat, problem)

#     display(og_sol)
#     display(vc_sat)
#     display(ham_sat)


#   end

# end


# @testset "Structure" begin
#   problem = SAT3(matrix2)

#   chainpath = shortest_chain(SAT3, Knapsack)

#   chaindata = chain_transform(problem, chainpath)


#   target = transform(problem, Knapsack)

# end

# @testset "ProblemTree" begin
#   struct Pies <: NPProblem
#     dums::UInt64
#   end

#   struct Kot
#     smart::UInt64
#   end

#   function Pies(inst::SAT3)
#     return Pies(1)
#   end

#   @test add_problem(Pies) == 12

#   @test_throws MethodError add_problem(Kot)

#   @test add_transformation(Pies, SAT3)

#   @test_throws MethodError add_transformation(Pies, VertexCover)


# end

@testset "Construct" begin
  problem = SAT3("../test_data/uf20-91/uf20-02.cnf")

  og_sol = solve(solver, problem)

  #vertex cover
  vc = VertexCover(problem)

  con = VertexCoverSolution(og_sol, problem)

  @test validate(con, vc)
end

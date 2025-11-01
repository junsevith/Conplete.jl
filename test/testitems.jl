# using Test
using JuMP
# using Concorde
using Conplete
using Graphs
using TestItems

Base.show(io::IO, x::T) where {T<:Union{Int,Int128,Int64,Int32,Int16,Int8}} = Base.print(io, x)

solver = try
  # throw(ErrorException("d"))
  using CPLEX

  CPLEX.Optimizer
catch
  using HiGHS

  HiGHS.Optimizer
end

struct Pies <: NPProblem
  dums::Int64
end

struct Ogon <: NPSolution
  dums::Int64
end

struct Kot
  smart::Int64
end

function Conplete.transform(inst::SAT3, target::Type{Pies})
  return Pies(1)
end

include("data.jl")

print("Using solver: ")
println(solver)


@testitem "Algorithms" begin
  @testset"Transform" begin
    println("Transform")
    @time begin
      # global sat3 = SAT3([1 2 3 ; 1 -2 3; 1 2 -3])
      global sat3 = SAT3(matrix2)
      # global sat3 = SAT3("../test_data/uf20-91/uf20-02.cnf")
      # global sat3 = SAT3("../test_data/UF250.1065.100/uf250-01.cnf")
      @test !isnothing(sat3)
    end

    @time global vc = transform(sat3, VertexCover)
    @test !isnothing(vc)

    @time global ham = transform(sat3, DirHamCycle)
    @test !isnothing(ham)

    @time global cli = transform(sat3, Clique)
    @test !isnothing(cli)

    @time global uham = transform(ham, HamCycle)
    @test !isnothing(uham)

  end

  @testset "Solve" begin
    println("Solve")

    @time global sat3_sol = solve(solver, sat3)
    @test validate(sat3_sol, sat3)

    @time global vc_sol = solve(solver, vc)
    @test validate(vc_sol, vc)

    @time global ham_sol = solve(solver, ham)
    @test validate(ham_sol, ham)

    @time global cli_sol = solve(solver, cli)
    @test validate(cli_sol, cli)

    @time global uham_sol = solve(solver, uham)
    @test validate(uham_sol, uham)

    # @time global uham_sol2 = solve(uham)
    # @test validate(uham_sol2, uham)
  end

  @testset "Extract" begin
    println("Extract")

    @time vc_sat = extract(vc_sol, sat3)
    @test validate(vc_sat, sat3)

    @time ham_sat = extract(ham_sol, sat3)
    @test validate(ham_sat, sat3)

    @time cli_sat = extract(cli_sol, sat3)
    @test validate(cli_sat, sat3)

    @time uham_ham = extract(uham_sol, ham)
    @test validate(uham_ham, ham)
  end

  @testset "Construct" begin
    println("Construct")
    @time vc_con = construct(VertexCoverSolution, sat3_sol, sat3)
    @test validate(vc_con, vc)

    @time ham_con = construct(DirHamCycleSolution, sat3_sol, sat3)
    @test validate(ham_con, ham)

    @time cli_con = construct(CliqueSolution, sat3_sol, sat3)
    @test validate(cli_con, cli)

    @time uham_con = construct(HamCycleSolution, ham_sol, ham)
    @test validate(uham_con, uham)
  end

end

@testitem "Problem Tree" begin

  @test add_problem(Pies, Ogon) == nothing

  @test_throws MethodError add_problem(Pies, Int)

  @test_throws MethodError add_problem(Kot, Int)

  @test add_transformation(Pies, SAT3) == nothing

  @test_throws MethodError add_transformation(Pies, VertexCover)

end

@testitem "Chain Transform" begin

  chainpath = shortest_chain(SAT3, Knapsack)

  @test last(chainpath) == Knapsack

  chaindata = chain_transform(sat3, chainpath)

  @test typeof(first(chaindata)) == SAT3
  @test typeof(last(chaindata)) == Knapsack

  chaindata = chain_transform(sat3, Knapsack)

  @test typeof(first(chaindata)) == SAT3
  @test typeof(last(chaindata)) == Knapsack

  target = transform(sat3, chainpath)

  @test typeof(target) == Knapsack

  target = transform(sat3, Knapsack)

  @test typeof(target) == Knapsack

end



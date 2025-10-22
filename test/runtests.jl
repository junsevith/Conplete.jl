using Test
using JuMP
using Concorde
using Conplete
using Graphs

Base.show(io::IO, x::T) where {T<:Union{UInt,UInt128,UInt64,UInt32,UInt16,UInt8}} = Base.print(io, x)

solver = try
  # throw(ErrorException("d"))
  using CPLEX

  CPLEX.Optimizer
catch
  using HiGHS

  HiGHS.Optimizer
end

struct Pies <: NPProblem
  dums::UInt64
end

struct Ogon <: NPSolution
  dums::UInt64
end

struct Kot
  smart::UInt64
end

function Conplete.transform(inst::SAT3, target::Type{Pies})
  return Pies(1)
end

include("data.jl")

print("Using solver: ")
println(solver)

@testset verbose = true "All Tests" begin


  @testset verbose = true "Algorithms" begin
    @testset "Transform" begin
      println("Transform")
      @time begin
        # global sat3 = SAT3([1 2 3 ; 1 -2 3; 1 2 -3])
        global ezsat3 = SAT3(matrix2)
        global sat3 = SAT3("../test_data/uf20-91/uf20-02.cnf")
        # global sat3 = SAT3("../test_data/UF250.1065.100/uf250-01.cnf")
        @test !isnothing(sat3)
      end

      @time global vc = transform(sat3, VertexCover)

      @time global ham = transform(sat3, DirHamCycle)

      @time global cli = transform(sat3, Clique)

      @time global ezham = transform(ezsat3, DirHamCycle)

      @time global uham = transform(ezham, HamCycle)

      @time global tsp = transform(uham, TSP)

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

      @time global ezham_sol = solve(solver, ezham)
      @test validate(ezham_sol, ezham)

      @time global uham_sol = solve(solver, uham)
      @test validate(uham_sol, uham)

      @time global tsp_sol = solve(tsp)
      @test validate(tsp_sol, tsp)
    end

    @testset "Extract" begin
      println("Extract")

      @time vc_sat = extract(vc_sol, sat3)
      @test validate(vc_sat, sat3)

      @time ham_sat = extract(ham_sol, sat3)
      @test validate(ham_sat, sat3)

      @time cli_sat = extract(cli_sol, sat3)
      @test validate(cli_sat, sat3)

      @time uham_ham = extract(uham_sol, ezham)
      @test validate(uham_ham, ezham)

      @time tsp_uham = extract(tsp_sol, uham)
      @test validate(tsp_uham, uham)
    end

    @testset "Construct" begin
      println("Construct")
      @time vc_con = construct(VertexCoverSolution, sat3_sol, sat3)
      @test validate(vc_con, vc)

      @time ham_con = construct(DirHamCycleSolution, sat3_sol, sat3)
      @test validate(ham_con, ham)

      @time cli_con = construct(CliqueSolution, sat3_sol, sat3)
      @test validate(cli_con, cli)

      @time uham_con = construct(HamCycleSolution, ezham_sol, ezham)
      @test validate(uham_con, uham)

      @time tsp_con = construct(TSPSolution, uham_sol, uham)
      @test validate(tsp_con, tsp)
    end

  end

  @testset verbose = true "Interfaces" begin
    @testset "Problem Tree" begin


      @test add_problem(Pies, Ogon) == nothing

      @test_throws MethodError add_problem(Pies, UInt)

      @test_throws MethodError add_problem(Kot, UInt)

      @test add_transformation(Pies, SAT3) == nothing

      @test_throws MethodError add_transformation(Pies, VertexCover)

    end

    @testset "Chain Transform" begin

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
  end


end
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

function test_algo(target::Type{<:NPProblem}, parent::NPProblem, parent_sol::NPSolution)
  res = transform(parent, target)

  @time sol = solve(solver, res)
  @test validate(sol, res)

  ext = extract(sol, parent)
  @test validate(ext, parent)

  con = construct(target, parent_sol, parent)
  @test validate(con, res)

  return (res, sol)
end

include("data.jl")

print("Using solver: ")
println(solver)

@testset verbose = true "All Tests" begin


  @testset verbose = true "Algorithms" begin
    @testset "import CNFSAT" begin
      @time global cnf = CNFSAT(cnfmatrix)

      @time global cnf_sol = solve(solver, cnf)
      @test validate(cnf_sol, cnf)
    end


    @testset "import 3SAT" begin
      begin
        # global sat3 = SAT3([1 2 3 ; 1 -2 3; 1 2 -3])
        global ezsat3 = SAT3(matrix2)
        global sat3 = SAT3("../test_data/uf20-91/uf20-02.cnf")
        # global sat3 = SAT3("../test_data/UF250.1065.100/uf250-01.cnf")
      end

      global sat3_sol = solve(solver, sat3)
      @test validate(sat3_sol, sat3)

      global ezsat3_sol = solve(solver, ezsat3)
      @test validate(ezsat3_sol, ezsat3)
    end

    @testset "CNFSAT->3SAT" begin
      global sat3_cnf = test_algo(SAT3, cnf, cnf_sol)
    end

    @testset "3SAT->VertexCover" begin
      global vc_sat3 = test_algo(VertexCover, sat3, sat3_sol)
    end

    @testset "3SAT->DirHamCycle" begin
      global ham_sat3 = test_algo(DirHamCycle, sat3, sat3_sol)
    end

    @testset "3SAT->Clique" begin
      global cli_sat3 = test_algo(Clique, sat3, sat3_sol)
    end

    @testset "3SAT->SubsetSum" begin
      global sub_sat3 = test_algo(SubsetSum, ezsat3, ezsat3_sol)
    end

    @testset "Clique->VertexCover" begin
      global cli_vc = test_algo(VertexCover, cli_sat3...)
    end

    @testset "DirHamCycle->HamCycle" begin
      global ezham = test_algo(DirHamCycle, ezsat3, ezsat3_sol)
      global uham_ham = test_algo(HamCycle, ezham...)
    end

    @testset "HamCycle->TSP" begin
      global tsp_uham = test_algo(TSP, uham_ham...)
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
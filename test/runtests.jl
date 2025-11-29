using Test
using JuMP
# using Concorde
using Conplete
using Graphs


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
        global ezsat4 = SAT3(matrix3)
        global sat3 = SAT3("../test_data/uf20-91/uf20-02.cnf")
        # global sat3 = SAT3("../test_data/UF250.1065.100/uf250-01.cnf")
      end

      global sat3_sol = solve(solver, sat3)
      @test validate(sat3_sol, sat3)

      global ezsat3_sol = solve(solver, ezsat3)
      @test validate(ezsat3_sol, ezsat3)

      global ezsat4_sol = solve(solver, ezsat4)
      @test validate(ezsat4_sol, ezsat4)
    end

    @testset "CNFSAT->3SAT" begin
      global sat3_cnf = test_algo(SAT3, cnf, cnf_sol)
    end

    @testset "3SAT->CNFSAT" begin
      _ = test_algo(CNFSAT, sat3, sat3_sol)
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

    @testset "Clique->VertexCover" begin
      global vc_cli = test_algo(VertexCover, cli_sat3...)
    end

    @testset "VertexCover->Clique" begin
      global cli_vc = test_algo(Clique, vc_sat3...)
    end

    @testset "DirHamCycle->HamCycle" begin
      global ezham = test_algo(DirHamCycle, ezsat3, ezsat3_sol)
      global uham_ham = test_algo(HamCycle, ezham...)
    end

    # @testset "HamCycle->TSP" begin
    #   global tsp_uham = test_algo(TSP, uham_ham...)
    # end

    @testset "VertexCover->HittingSet" begin
      global hit_vc = test_algo(HittingSet, vc_sat3...)
    end

    @testset "3SAT->SubsetSum" begin
      global sub_sat3 = test_algo(SubsetSum, ezsat4, ezsat4_sol)
    end

    @testset "SubsetSum->Partition" begin
      global par_sub = test_algo(Partition, sub_sat3...)
    end

    @testset "Partition->BinPacking" begin
      global bin_par = test_algo(BinPacking, par_sub...)
    end

    @testset "Partition->Knapsack" begin
      global knap_par = test_algo(Knapsack, par_sub...)
    end

    @testset "Partition->SubsetSum" begin
      global sub_par = test_algo(SubsetSum, par_sub...)
    end

    @testset "SubsetSum->Knapsack" begin
      global knap_sub = test_algo(Knapsack, sub_sat3...)
    end

  end

  @testset verbose = true "Interfaces" begin
    @testset "Problem Tree" begin


      @test add_problem(Pies, Ogon) == nothing

      @test_throws MethodError add_problem(Pies, Int)

      @test_throws MethodError add_problem(Kot, Int)

      @test add_transformation(Pies, SAT3) == nothing

      @test_throws MethodError add_transformation(Pies, VertexCover)

    end

    @testset "Chain Transform" begin

      chainpath = shortest_chain(SAT3, Knapsack)

      @test last(chainpath) == Knapsack

      chaindata = chain_transform(sat3, chainpath)

      @test typeof(first(chaindata)) == SAT3
      @test typeof(last(chaindata)) == Knapsack{BigInt,BigInt}

      chaindata = chain_transform(sat3, Knapsack)

      @test typeof(first(chaindata)) == SAT3
      @test typeof(last(chaindata)) == Knapsack{BigInt,BigInt}

      target = transform(sat3, chainpath)

      @test typeof(target) == Knapsack{BigInt,BigInt}

      target = transform(sat3, Knapsack)

      @test typeof(target) == Knapsack{BigInt,BigInt}

    end
  end

  @testset "Optional parameters" begin
    parent, parent_sol = sat3, sat3_sol

    res = transform(parent, CNFSAT)

    @time sol = solve(solver, res)
    @test validate(sol, res)

    ext = extract(sol, parent)
    @test validate(ext, parent)

    con = construct(CNFSATSolution, parent_sol)
    @test validate(con, res)
  end


end
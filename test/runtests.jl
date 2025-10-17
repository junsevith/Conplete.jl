using Test
using JuMP
using Conplete
using Graphs

Base.show(io::IO, x::T) where {T<:Union{UInt,UInt128,UInt64,UInt32,UInt16,UInt8}} = Base.print(io, x)

# solver = try
#   using CPLEX

#   CPLEX.Optimizer
# catch
#   using HiGHS

#   HiGHS.Optimizer
# end

using HiGHS

solver = HiGHS.Optimizer

include("data.jl")

print("Using solver: ")
println(solver)

@testset verbose = true "All Tests" begin


  @testset verbose = true "Algorithms" begin
    @testset "Transform" begin
      println("Transform")
      @time begin
        # global sat3 = SAT3([1 2 3 ; 1 -2 3; 1 2 -3])
        # global sat3 = SAT3(matrix2)
        global sat3 = SAT3("../test_data/uf20-91/uf20-02.cnf")
        # global sat3 = SAT3("../test_data/UF250.1065.100/uf250-01.cnf")
        @test !isnothing(sat3)
      end

      @time global vc = transform(sat3, VertexCover)
      @test !isnothing(vc)


      @time global ham = transform(sat3, HamiltonianCycle)
      @test !isnothing(ham)

      @time global cli = transform(sat3, Clique)
      @test !isnothing(cli)

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
    end

    @testset "Extract" begin
      vc_sat = extract(vc_sol, sat3)
      @test validate(vc_sat, sat3)

      ham_sat = extract(ham_sol, sat3)
      @test validate(ham_sat, sat3)
    end

    @testset "Construct" begin
      vc_con = construct(VertexCoverSolution, sat3_sol, sat3)
      @test validate(vc_con, vc)

      ham_con = construct(HamiltonianCycleSolution, sat3_sol, sat3)
      @test validate(ham_con, ham)

    end

  end

  @testset verbose = true "Interfaces" begin
    @testset "Problem Tree" begin
      struct Pies <: NPProblem
        dums::UInt64
      end

      struct Ogon <: NPSolution
        dums::UInt64
      end

      struct Kot
        smart::UInt64
      end

      function Pies(inst::SAT3)
        return Pies(1)
      end

      @test add_problem(Pies, Ogon) == Nothing

      @test_throws MethodError add_problem(Pies, UInt)

      @test_throws MethodError add_problem(Kot, UInt)

      @test add_transformation(Pies, SAT3) == Nothing

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
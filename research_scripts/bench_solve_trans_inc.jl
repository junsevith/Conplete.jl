using Conplete
using BenchmarkTools
using Graphs
using CPLEX
using JuMP

solver = CPLEX.Optimizer

include("save_data.jl")

function bench(problem, name, path, sec=10)
    suite = BenchmarkGroup()

    x = problem

    suite[SAT3] = @benchmarkable solve($solver, $x)

    for p in path
        # println(p)

        x = transform(x, p)

        suite[p] = @benchmarkable solve($solver, $x)

    end

    println("tuning")

    # tune!(suite)

    println("running")

    results = run(suite, verbose=true, samples=30)

    # save_group(path, mean(results), name)

    pushfirst!(path, SAT3)

    save2(path, results, "solve_trans_inc/"* name)
end

fil = SAT3("test_data/uf20-91/uf20-02.cnf")

# bench(fil, "cli", [Clique, VertexCover, HittingSet])
# bench(fil, "hit", [VertexCover, HittingSet])

smol = [
  1 -2 -3
  -1 2 -4
  3 -4 -5
  1 4 -5
  -2 3 5
  1 -3 -4
  2 -4 -5
  -1 3 5
  1 2 -5
  -2 4 5
  3 -1 -2
  4 -3 -5
  5 -1 -2
  1 3 -4
  2 4 5
  3 4 -5
  1 -2 5
  2 -3 4
  1 4 5
  2 3 5
]

bench(SAT3(smol), "knap", [SubsetSum, Partition, Knapsack])
# bench("bin", [SubsetSum, Partition, BinPacking])
# bench("ham", [DirHamCycle, HamCycle, TSP])

# bench(fil, "cli", [Clique, VertexCover, HittingSet, SubsetSum, Partition,BinPacking, Knapsack,DirHamCycle, HamCycle, TSP])
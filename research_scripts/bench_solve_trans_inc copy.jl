using Conplete
using BenchmarkTools
using Graphs
using CPLEX
using JuMP
using Concorde
using HiGHS

include("save_data.jl")

# solve(s, i::TSP) = Conplete.solve(i)

function model_setup(seed::Int32=42)
  model = Model(CPLEX.Optimizer)
  set_attribute(model, "CPX_PARAM_RANDOMSEED", seed)
  set_attribute(model, "CPX_PARAM_PARALLELMODE", 1)
  set_silent(model)
  return model
end

function bench1(problem, name, path::Vector{Type{<:NPProblem}})
  suite = BenchmarkGroup()

  inst = chain_transform(problem, path)

  types = map(typeof, inst)

  for i in inst
    suite[typeof(i)] = @benchmarkable z = solve(model_setup(seed), $i) setup=(display($i);seed=rand(Int32(1):Int32(2000000000));display(seed))
  end

  println("tuning")

  # tune!(suite, p=pars)

  println("running")

  # display(params(suite))

  results = run(
    suite, 
    verbose=true,
    samples=10,
    seconds=100000,
    gctrial=true,
    gcsample=true,
    )

  # display(params(suite))

  # save_group(path, mean(results), name)

  save2(types, results, "solve_trans_inc/" * name)

  return results
end

# fil = SAT3("test_data/lin_increase/n020m091.cnf")
# fil = SAT3("test_data/lin_increase/n050m218.cnf")
fil = SAT3("test_data/lin_increase/n075m325.cnf")
# fil = SAT3("test_data/lin_increase/n100m430.cnf")

# res = bench1(fil, "cli", Vector{Type{<:NPProblem}}([Clique, VertexCover]))
# res = bench1(fil, "cli", Vector{Type{<:NPProblem}}([Clique, VertexCover, HittingSet]))
# bench1(fil, "hit", Vector{Type{<:NPProblem}}([VertexCover, HittingSet]))

smol = [
  1 2 3
  1 2 -3
  1 -2 3
  1 -2 -3
  -1 2 3
  -1 2 -3
  -1 -2 3
  # -1 -2 -3
]

# bench1(SAT3(smol), "knap", Vector{Type{<:NPProblem}}([SubsetSum, Partition, Knapsack]))
# bench1("bin", [SubsetSum, Partition, BinPacking])


matrix2 = [
  1 -2 3
  -1 4 5
  2 -3 -4
  -2 3 5
  1 4 -5
  -1 -2 5
  3 -4 -5
  1 2 -4
  -3 4 5
  -1 3 -5
  2 4 -5
  1 -3 4
  -2 -4 5
  -1 2 -3
  3 4 -5
  1 -2 -5
  -1 -3 4
  2 -4 5
  -2 3 -5
  1 -4 -5
]

bench1(SAT3(matrix2), "ham", Vector{Type{<:NPProblem}}([DirHamCycle, HamCycle, TSP]))

# bench1(fil, "cli", [Clique, VertexCover, HittingSet, SubsetSum, Partition,BinPacking, Knapsack,DirHamCycle, HamCycle, TSP])
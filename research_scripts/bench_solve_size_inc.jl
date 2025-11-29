using Conplete
using BenchmarkTools
using Graphs
using CPLEX
using JuMP

include("save_data.jl")

function bench(dirname, name, path::Vector{Type{<:NPProblem}})
    # dirname = "test_data/BMS_k3_n100_m429"
    # dirname = "test_data/CBS_k3_n100_m403_b10"
    # dirname = "test_data/RTI_k3_n100_m429"
    # dirname = "test_data/uf20-91"
    # dirname = "test_data/UF250.1065.100"
    # dirname = "test_data/lin_increase_smaller"

    dir = readdir(dirname)

    display(dir)

    suite = BenchmarkGroup()

    for file in dir
        println(file)

        problem = SAT3(dirname * "/" * file)
        x = problem

        suite[SAT3][file] = @benchmarkable solve($CPLEX.Optimizer, $x)

        for p in path
            # println(p)

            x = transform(x, p)

            suite[p][file] = @benchmarkable solve($CPLEX.Optimizer, $x)

        end
    end

    println("tuning")

    # tune!(suite)

    println("running")

    results = run(suite, verbose=true, seconds=10)

    pushfirst!(path, SAT3)

    display(results)

    for p in path
        save2(dir, results[string(p)], "solve_size_inc/" * name * string(p) )
    end
end

# bench("test_data/lin_increase", "sat_", [])
# bench("test_data/lin_increase_smaller", "cli_", [Clique, VertexCover, HittingSet])
# bench("test_data/lin_increase", "hit_", Vector{Type{<:NPProblem}}([HittingSet]))
bench("test_data/lin_increase_small", "hit_", Vector{Type{<:NPProblem}}([VertexCover, HittingSet]))
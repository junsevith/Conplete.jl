using Conplete
using BenchmarkTools
using Graphs
using CPLEX
using JuMP

include("save_data.jl")

function model_setup(seed::Int32=42)
    model = Model(CPLEX.Optimizer)
    set_attribute(model, "CPX_PARAM_RANDOMSEED", seed)
    set_attribute(model, "CPX_PARAM_PARALLELMODE", 1)
    set_silent(model)
    return model
end

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

    types = []

    for file in dir
        println(file)

        problem = SAT3(dirname * "/" * file)

        inst = chain_transform(problem, path)

        types = map(typeof, inst)

        for i in inst
            suite[typeof(i)][file] = @benchmarkable z = solve(model_setup(seed), $i) setup = (display($i); seed = rand(Int32(1):Int32(2000000000)); display(seed))
        end
    end

    println("tuning")

    # tune!(suite)

    println("running")

    results = run(
        suite,
        verbose=true,
        samples=30,
        seconds=100000,
        gctrial=true,
        gcsample=true,
    )


    display(results)

    for p in types
        save2(dir, results[string(p)], "solve_size_inc/" * name * string(p))
    end
end

bench("test_data/lin_increase", "sat_", Vector{Type{<:NPProblem}}([]))
# bench("test_data/lin_increase_smaller", "cli_", [Clique, VertexCover, HittingSet])
# bench("test_data/lin_increase", "hit_", Vector{Type{<:NPProblem}}([HittingSet]))
# bench("test_data/lin_increase_small", "hit_", Vector{Type{<:NPProblem}}([VertexCover, HittingSet]))
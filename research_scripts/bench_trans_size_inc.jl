using Conplete
using BenchmarkTools
using Graphs

include("save_data.jl")

function bench(name, path)
    # dirname = "test_data/BMS_k3_n100_m429"
    # dirname = "test_data/CBS_k3_n100_m403_b10"
    # dirname = "test_data/RTI_k3_n100_m429"
    # dirname = "test_data/uf20-91"
    # dirname = "test_data/UF250.1065.100"
    dirname = "test_data/lin_increase"

    dir = readdir(dirname)

    display(dir)

    suite = BenchmarkGroup()

    for file in dir
        println(file)

        problem = SAT3(dirname * "/" * file)
        x = problem

        for p in path
            # println(p)

            suite[p][file] = @benchmarkable transform($x, $p)

            x = transform(x, p)

        end
    end

    println("tuning")

    # tune!(suite)

    println("running")

    results = run(suite, verbose=true, samples=30)

    # save_group(path, mean(results), name)

    for p in path
        save2(dir, results[string(p)], "trans_size_inc/" * name * string(p) )
    end
end

# bench("lin_cli", [Clique])
bench("cli_", [Clique, VertexCover, HittingSet])
bench("hit_", [VertexCover, HittingSet])
bench("knap_", [SubsetSum, Partition, Knapsack])
bench("bin_", [SubsetSum, Partition, BinPacking])
bench("ham_", [DirHamCycle, HamCycle, TSP])
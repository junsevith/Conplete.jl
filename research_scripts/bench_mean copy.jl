using Conplete
using BenchmarkTools
using Graphs

include("save_data.jl")

# # dirname = "test_data/BMS_k3_n100_m429"
# # dirname = "test_data/CBS_k3_n100_m403_b10"
# # dirname = "test_data/RTI_k3_n100_m429"
# # dirname = "test_data/uf20-91"
# # dirname = "test_data/UF250.1065.100"
# dirname = "test_data/check"

# path = [DirHamCycle, HamCycle, TSP]

# dir = readdir(dirname)

# suite = BenchmarkGroup()

# for file in dir
#     println(file)

#     problem = SAT3(dirname * "/" * file)
#     x = problem

#     for p in path
#         # println(p)

#         suite[p][file] = @benchmarkable transform($x, $p)

#         x = transform(x, p)

#     end
# end

# println("tuning")

# tune!(suite);

# println("running")

# results = run(suite, verbose=true, seconds=1)

# save_group(path, mean(results), "dupa")

function bench(name, path)
    # dirname = "test_data/BMS_k3_n100_m429"
    # dirname = "test_data/CBS_k3_n100_m403_b10"
    # dirname = "test_data/RTI_k3_n100_m429"
    # dirname = "test_data/uf20-91"
    # dirname = "test_data/UF250.1065.100"
    dirname = "test_data/check"

    dir = readdir(dirname)

    suite = BenchmarkGroup()

    for file in dir
        println(file)

        x = SAT3(dirname * "/" * file)

        for p in path
            # println(p)

            suite[p][file] = @benchmarkable transform($x, $p)

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

    save_group(path, mean(results),"trans_pro_comp/" * name)
end

bench("cli", [Clique, VertexCover, DirHamCycle, SubsetSum, CNFSAT])
# bench("cli", [VertexCover, HittingSet])
# bench("knap", [SubsetSum, Partition, Knapsack])
# bench("bin", [SubsetSum, Partition, BinPacking])
# bench("ham", [DirHamCycle, HamCycle, TSP])
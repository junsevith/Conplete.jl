using Conplete
using BenchmarkTools
using Graphs

include("save_data.jl")

let 
    sat3 = SAT3("test_data/UF250.1065.100/uf250-01.cnf")

    path = [DirHamCycle, HamCycle, TSP]

    data = []

    x = sat3

    for p in path
        println(x)

        t = @benchmark transform($x, $p)
        push!(data,t)

        x = transform(x, p)

    end

    # @benchmark map!(x -> 1-x, Matrix(Graphs.adjacency_matrix($x.graph)))


    # display.(median.(data))
    display.(data)

    save(path, data, "dupa")
end


include("../SAT3.jl")
using Statistics

# dirname = "test_data/BMS_k3_n100_m429"
dirname = "test_data/CBS_k3_n100_m403_b10"
# dirname = "test_data/RTI_k3_n100_m429"
# dirname = "test_data/uf20-91"
# dirname = "test_data/UF250.1065.100"

dir = readdir(dirname)

for file in dir
    problem = SAT3(dirname * "/" * file)

    # println(problem.variable_count)
    # display(problem.clauses)

    matrix = problem.clauses
    len = problem.variable_count
    countp = [0 for _ in 1:len]
    countn = [0 for _ in 1:len]

    for i in axes(matrix, 1), j in 1:3
        el = matrix[i, j]
        if el < 0
            countn[-el] += 1
        else
            countp[el] += 1
        end
    end

    # display([ (i, countp[i], countn[i]) for i in 1:len])

    stats = [(i, max(countp[i], countn[i])) for i in 1:len]

    d = map(x -> x[2], stats)
    display(mean(d))
    display(median(d))
     display(middle(d))

    sort!(stats, lt=(x, y) -> x[2] < y[2])

    # display(stats)

    l = size(matrix,1)

    sud = 6 * l
    kt = l

    sude = 2 * l + 9 * l
    kte = 2 * l

    for v in stats
        if v[2] != 0
            sud += v[2] + 1
            kt += 3 * v[2] + 3

            sude += 4 + 2 * (v[2] + 1)
            kte += 4 + 2 * (3 * v[2] + 3)
        end
    end

    println("Sudkamp vertices:$(sud) edges:$(sude)")
    println("K-T     vertices:$(kt) edges:$(kte)")
    println()
    
end
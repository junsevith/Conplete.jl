struct SubsetSum <: NPProblem
    set::Vector{BigInt}
    sum::BigInt
end


function transform(inst::SAT3, target::Type{SubsetSum})
    n = inst.variable_count
    m = size(inst.clauses, 1)
    set = [BigInt(i < n ? 3 : 1) << 2i for i in repeat(0:(n+m-1), inner=2)]

    variable(x::Int) = x > 0 ? 2x - 1 : 2-x
    clause(x::Int) = 2n + 2x

    for c in axes(inst.clauses, 1), d in 1:3
        set[variable(inst.clauses[c, d])] += set[clause(c)]
    end

    sum = parse(BigInt, repeat('3', n + m), base=4)


    return SubsetSum(set, sum)
end
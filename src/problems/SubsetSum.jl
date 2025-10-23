struct SubsetSum{T<:Number} <: NPProblem
    set::Vector{T}
    sum::BigInt
end

struct SubsetSumSolution
    subset::BitArray
end


function transform(inst::SAT3, target::Type{SubsetSum})
    n = inst.variable_count
    m = size(inst.clauses, 1)

    # numbers from 1 to 2n correspond to variables
    #   2k-1 being positive variable for k ∈ N
    #   2k being negative variables
    # numbers from 2n onward are clause filler variables
    # which enable multiple variables satisfying the same clause
    set = [BigInt(i < n ? 3 : 1) << 2i for i in repeat(0:(n+m-1), inner=2)]

    variable(x::Int) = x > 0 ? 2x - 1 : -2x
    clause(x::Int) = 2n + 2x

    # variable x satisfies clause c
    for c in axes(inst.clauses, 1)
        clnum = set[clause(c)]
        for d in 1:3
            set[variable(inst.clauses[c, d])] += clnum
        end
    end

    # we need to choose valuation for each variable and make every clause satisfied
    sum = parse(BigInt, repeat('3', n + m), base=4)

    # foreach(x -> println(string(x, base=4, pad=n+m)), set)

    return SubsetSum{BigInt}(set, sum)
end

function validate(sol::SubsetSumSolution, problem::SubsetSum)
    return problem.sum == sum(problem.set .* sol.subset)
end

function extract(sol::SubsetSumSolution, sat::SAT3)
    return SAT3Solution([sol.subset[i] for i in 1:2:(2*sat.variable_count)])
end

function construct(target::Type{SubsetSumSolution}, sol::SAT3Solution, parent::SAT3)
    n = parent.variable_count
    m = size(parent.clauses, 1)

    subset = falses( 2n + 2m)

    for (i, v) in enumerate(sol.evaluation)
        if v
            subset[2i-1] = true
        else
            subset[2i] = true
        end
    end

    eval(x::Int) = x > 0 ? sol.evaluation[x] : !sol.evaluation[-x]

    for c in axes(parent.clauses, 1)
        cnt = sum(eval.(parent.clauses[c, :]))

        if cnt < 3
            subset[2n+2c-1] = true
        end

        if cnt < 2
            subset[2n+2c] = true
        end
    end

    return SubsetSumSolution(subset)
end
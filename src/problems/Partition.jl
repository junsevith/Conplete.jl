function validate(sol::PartitionSolution, inst::Partition)
    s1 = 0
    s2 = 0

    for (i, v) in enumerate(inst.set)
        if i ∈ sol.subset
            s1 += v
        else
            s2 += v
        end
    end

    return s1 == s2
end


function transform(inst::SubsetSum{<:Integer}, target::Type{Partition})
    neg = any(x -> x < 0, inst.set)
    s = sum(inst.set)
    return if neg
        Partition([inst.set; inst.sum + s; 2s - inst.sum])
    else
        Partition([inst.set; 2 * inst.sum - s])
    end
end

function extract(sol::PartitionSolution, inst::SubsetSum) 
    fill = (length(inst.set) + 1)

    subset = if fill ∈ sol.subset
        # we have the other set
        setdiff(inst.set, sol.subset)
    else
        # we have the right set
        deepcopy(sol.subset)
    end

    delete!(subset, fill + 1)

    return SubsetSumSolution(subset)
end

function construct(target::Type{PartitionSolution}, sol::SubsetSumSolution, parent::SubsetSum)
    set = deepcopy(sol.subset)

    if all(x -> x >= 0, parent.set)
        push!(set, length(parent.set) + 2)
    end

    return PartitionSolution(set)
end

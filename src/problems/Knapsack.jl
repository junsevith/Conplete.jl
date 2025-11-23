function validate(sol::KnapsackSolution, inst::Knapsack)
    size = 0
    value = 0

    for e in sol.subset
        size += inst.elements[e]
        value += inst.values[e]
    end

    return size <= inst.size && value >= inst.min_value

end

function transform(inst::Partition, target::Type{Knapsack})
    v = _safehalf(sum(inst.elements))
    return Knapsack(inst.elements, inst.elements, v, v)
end

function extract(sol::KnapsackSolution, parent::Partition)
   return PartitionSolution(sol.subset)
end

function construct(target::Type{KnapsackSolution}, sol::PartitionSolution, parent::Partition)
   return KnapsackSolution(sol.subset)
end

function transform(inst::SubsetSum, target::Type{Knapsack})
    return Knapsack(inst.elements, inst.elements, inst.sum, inst.sum)
end

function extract(sol::KnapsackSolution, parent::SubsetSum)
   return SubsetSumSolution(sol.subset)
end

function construct(target::Type{KnapsackSolution}, sol::SubsetSumSolution, parent::SubsetSum)
   return KnapsackSolution(sol.subset)
end
struct Knapsack <: NPProblem
    dummy::Int
end


function transform(inst::Partition, target::Type{Knapsack})
    return Knapsack(1)
end
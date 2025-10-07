struct Knapsack <: NPProblem
    dummy::Int
end


function Knapsack(inst::Partition)
    return Knapsack(1)
end
struct Partition <: NPProblem
    dummy::Int
end

function transform(inst::SubsetSum, target::Type{Partition})
    return Partition(1)
end
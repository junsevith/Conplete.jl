struct Partition <: NPProblem
    dummy::Int
end

function Partition(inst::SubsetSum)
    return Partition(1)
end
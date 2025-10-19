struct SubsetSum <: NPProblem
    dummy::Int
end


function transform(inst::SAT3, target::Type{SubsetSum})
    return SubsetSum(1)
end
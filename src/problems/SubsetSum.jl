struct SubsetSum <: NPProblem
    dummy::Int
end


function SubsetSum(inst::SAT3)
    return SubsetSum(1)
end
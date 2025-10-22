struct SubsetSum <: NPProblem
    set::Vector{BigInt}
end


function transform(inst::SAT3, target::Type{SubsetSum})
    return SubsetSum([])
end
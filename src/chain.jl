function shortest_chain(in::DataType,out::DataType)
    in_num = problems[in]
    out_num = problems[out]
    path = a_star(problemGraph, in_num, out_num)
    return [problems(dst(e)) for e in path]
end

function chain_transform(instance::NPProblem , chain_path::Array{DataType})
    chaindata = []

    inst = instance
    for problem_type in chain_path
        inst = problem_type(inst)
        push!(chaindata, inst)
    end

    return chaindata
end

function chain_transform(instance::NPProblem, target::Type{T}) where T <: NPProblem
    chaindata = []

    inst = instance
    for problem_type in shortest_chain(typeof(instance), target)
        inst = problem_type(inst)
        push!(chaindata, inst)
    end

    return chaindata
end

function transform(instance::NPProblem, target::Type{T}) where T <: NPProblem

    inst = instance
    for problem_type in shortest_chain(typeof(instance), target)
        inst = problem_type(inst)
    end
    return inst
end
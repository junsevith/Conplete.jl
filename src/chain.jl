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

# [`add_problem`](@ref) and [`add_transformation`](@ref)
"""
    transform(instance, target_type) -> target_instance

Transform `instance` of an NP complete problem into `target_instance` of `target_type` type.

It is only possible if there exists a chain of transformations from `instance` type into `target_type` type which is recorded in the package's transformation graph.

Check  for adding transformations into transformation graph

# Arguments

`instance::NPProblem`: input instance of the problem.

`target_type::Type{T} where T <: NPProblem`: target type of the output instance of the problem.
# Examples
```jldoctest
julia> using Conplete
julia> transform(SAT3([1 2 3]), VertexCover)
Instance of problem VertexCover
```
"""
function transform(instance::NPProblem, target_type::Type{T}) where T <: NPProblem

    inst = instance
    for problem_type in shortest_chain(typeof(instance), target_type)
        inst = problem_type(inst)
    end
    return inst
end
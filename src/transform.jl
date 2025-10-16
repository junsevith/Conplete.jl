"""
    shortest_chain(in,out)

Find the shortest chain of conversions between problem of type `in` and problem of type `out` and return it as an array of corresponding types.

Output array can be then used in `chain_transform` function.

# Examples
```jldoctest
julia> shortest_chain(CNFSAT,Knapsack)
4-element Vector{DataType}:
 SAT3
 SubsetSum
 Partition
 Knapsack
    ```    
"""
function shortest_chain(in::Type{<:NPProblem}, out::Type{<:NPProblem})
    in_num = problems[in]
    out_num = problems[out]
    path = a_star(problemGraph, in_num, out_num)
    return [problems(dst(e)) for e in path]
end

"""
    chain_transform(instance, target_type) -> chain

Transform `instance` of an NP complete problem into instance of `target_type` type, while returning whole chain of intermediate problems.

It is only possible if there exists a chain of transformations from `instance` type into `target_type` type which is recorded in the package's transformation graph.

Check [`add_problem`](@ref) and [`add_transformation`](@ref) for adding transformations into transformation graph

# Arguments

`instance::NPProblem`: input instance of the problem.

`target_type::Type{<:NPProblem}`: target type of the last transformation
# Examples
```jldoctest
julia> using Conplete
julia> transform(SAT3([1 2 3]), VertexCover)
Instance of problem VertexCover
    ```
"""
chain_transform(instance::NPProblem, target_type::Type{<:NPProblem}) = chain_transform(instance, shortest_chain(typeof(instance), target_type))

"""
    chain_transform(instance , chain_path) -> chain

Transform `instance` of an NP complete  according to `chain_path`, while returning whole chain of intermediate problems.

It is only possible if there exists a chain of transformations from `instance` type matching `chain_path` which is recorded in the package's transformation graph.

Check [`add_problem`](@ref) and [`add_transformation`](@ref) for adding transformations into transformation graph

# Arguments

`instance::NPProblem`: input instance of the problem.

`chain_path::Array{DataType}`: chain of conversions as an array of problem types.
# Examples
```jldoctest
julia> using Conplete
julia> transform(SAT3([1 2 3]), [VertexCover,Clique])
Instance of problem Clique
```
"""
function chain_transform(instance::NPProblem, chain_path::Vector{DataType})
    chaindata = Vector{NPProblem}([instance])

    inst = instance
    for problem_type in chain_path
        inst = problem_type(inst)
        push!(chaindata, inst)
    end

    return chaindata
end

"""
    transform(instance , chain_path) -> target_instance

Transform `instance` of an NP complete  according to `chain_path`, while returning only the last instance.

It is only possible if there exists a chain of transformations from `instance` type matching `chain_path` which is recorded in the package's transformation graph.

When transformation of solutions is needed [`chain_transform`](@ref) should be used instead.

Check [`add_problem`](@ref) and [`add_transformation`](@ref) for adding transformations into transformation graph

# Arguments

`instance::NPProblem`: input instance of the problem.

`chain_path::Array{DataType}`: chain of conversions as an array of problem types.
# Examples
```jldoctest
julia> using Conplete
julia> transform(SAT3([1 2 3]), [VertexCover,Clique])
Instance of problem Clique
"""
function transform(instance::NPProblem, chain_path::Vector{DataType})

    inst = instance
    for problem_type in chain_path
        inst = problem_type(inst)
    end
    return inst
end


# [`add_problem`](@ref) and [`add_transformation`](@ref)
"""
    transform(instance, target_type) -> target_instance

Transform `instance` of an NP complete problem into `target_instance` of `target_type` type.

It is only possible if there exists a chain of transformations from `instance` type into `target_type` type which is recorded in the package's transformation graph.

When transformation of solutions is needed [`chain_transform`](@ref) should be used instead.

Check [`add_problem`](@ref) and [`add_transformation`](@ref) for adding transformations into transformation graph

# Arguments

`instance::NPProblem`: input instance of the problem.

`target_type::Type{<:NPProblem}`: target type of the output instance of the problem.
# Examples
```jldoctest
julia> using Conplete
julia> transform(SAT3([1 2 3]), VertexCover)
Instance of problem VertexCover
```
"""
transform(instance::NPProblem, target_type::Type{<:NPProblem}) = transform(instance, shortest_chain(typeof(instance), target_type))
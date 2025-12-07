using IterTools

"""
    construct(solution, chain) -> target_solution

Using `solution` of the base problem, construct the `target_solution` for problem that is result of the transformation of said base problem.

`chain` includes base problem, target problem and all inbetween problem instances computed during transformation, all of them are needed for this operation.

# Examples
```jldoctest
julia> using Conplete
julia> x = chain_transform(SAT3([1 2 3]), HittingSet)
3-element Vector{NPProblem}:
 Instance of problem SAT3
 Instance of problem VertexCover
 Instance of problem HittingSet{Set{Int64}}
julia> construct(SAT3Solution(Bool[1,1,0]), x)
HittingSetSolution{Set{Int64}}(Set([6, 2, 9, 8, 1]))
```
"""
function construct(solution::NPSolution, chain::Vector{NPProblem})
    current = solution
    for (parent, child) in partition(chain, 2, 1)
        sol_type = solution_type(child)
        current = construct(sol_type, current, parent)
    end
    return current
end


"""
    construct(target_type, solution, problem) -> target_solution

Using `solution` of the base `problem`, construct the `target_solution` for problem of `target_type` that is result of the transformation of said base problem.

See also: [`chain_transform`](@ref)

# Examples
```jldoctest
julia> using Conplete
julia> construct(VertexCover, SAT3Solution(Bool[1,1,0]), SAT3([1 2 3]))
VertexCoverSolution{Set{Int64}}(Set([6, 2, 9, 8, 1]))
```
"""
function construct end
# construct(target::Type{<:NPSolution}, solution::NPSolution, problem::NPProblem) = construct(solution, chain_transform(problem, problem_type(target)))


construct(target::Type{<:NPProblem}, solution::NPSolution, problem::NPProblem) = construct(solution_type(target), solution, problem)

construct(target::Type{<:NPProblem}, solution::NPSolution) = construct(solution_type(target), solution)
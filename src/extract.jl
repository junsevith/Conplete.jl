"""
    extract(solution, instance_chain) -> target_solution
From `solution` of the child problem extract the solution of the parent problem that was base for child problem when transformation was performed.

`instance_chain` contains all problem instances that were produced during chain transformation

Depth specifies how deep to extract when problem is a result of multiple transformations.

# Examples
```jldoctest
julia> using Conplete
julia> x = chain_transform(SAT3([1 2 3]), HittingSet)
3-element Vector{NPProblem}:
 Instance of problem SAT3
 Instance of problem VertexCover
 Instance of problem HittingSet{Set{Int64}}
julia> extract(HittingSetSolution(Set([1,3,6])), x)
SAT3Solution(Bool[1, 0, 1])
```
"""
extract(solution::NPSolution, chain::Vector{NPProblem}) = foldl(extract, Iterators.reverse(Iterators.filter(x -> clean_type(typeof(x)) != problem_type(solution)  ,chain)); init=solution)


"""
    extract(solution, parent_problem) -> parent_solution
From `solution` of the problem instance that was result of the transformation, extract solution of the parent `problem`.

See also: [`chain_transform`](@ref)

# Examples
```jldoctest
julia> using Conplete
julia> extract(VertexCoverSolution(Set([1,3,6])), SAT3([1 2 3]))
SAT3Solution(Bool[1, 0, 1])
```
"""
function extract end
# extract(solution::NPSolution, problem::NPProblem) = extract(solution, chain_transform(problem, problem_type(typeof(solution))))




using IterTools

"""
    construct(solution, chain) -> target_solution

Using `solution` of the base problem, construct the `target_solution` for problem that is result of the transformation of said base problem.

`chain` includes base problem, target problem and all inbetween problem instances computed during transformation, all of them are needed for this operation.
"""
function construct(solution::NPSolution, chain::Vector{NPProblem})

    current = solution
    for (parent, child) in partition(chain, 2, 1)
        sol_type = solutions[typeof(child)]
        current = sol_type(solution, parent)
    end
    return current
end


"""
    construct(target_type, solution, problem) -> target_solution

Using `solution` of the base `problem`, construct the `target_solution` for problem of `target_type` that is result of the transformation of said base problem.

If type of `solution` and `target_type` are separated in transformation graph by more than one transformation, the instance `problem` needs to be transformed which will be slower

Therefore it is advised to use the method `construct(solution::NPSolution, chain::Vector{NPProblem})` in this situation.

See also: [`chain_transform`](@ref)
"""
function construct(target::Type{NPSolution}, solution::NPSolution, problem::NPProblem)
    return try
        target(solution, problem)
    catch
        construct(solution, chain_transform(problem, solutions(target)))
    end
end

construct(target::Type{<:NPProblem}, solution::NPSolution, problem::NPProblem) = construct(solutions[target], solution, problem)
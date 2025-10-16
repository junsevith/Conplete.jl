struct VertexCover <: NPProblem
    graph::SimpleGraph
    size::UInt
end

struct VertexCoverSolution <: NPSolution
    cover::Set{UInt}
end

function validate(solution::VertexCoverSolution, problem::VertexCover)
    if length(solution.cover) > problem.size
        return ErrorException("solution too large")
    end

    for e in edges(problem.graph)
        if !(src(e) in solution.cover) && !(dst(e) in solution.cover)
            println(e)
            return ErrorException("edge that is not covered")
        end
    end

    return true
end

"""
conversion of 3SAT to VertexCover problem
"""
function transform(sat3::SAT3, target::Type{VertexCover})

    # vertex x corresponds to variable x in 3sat
    # vertex sat3.variable_count + x correspontd to ¬x
    # vertex 2*sat3.variable_count + 3*(i-1) + (j-1) corresponds to element j of clause i

    graph = SimpleGraph(sat3.variable_count * 2 + length(sat3.clauses))

    elementsCounter = 2 * sat3.variable_count
    # we add edge between variable and its negation

    for v in 1:sat3.variable_count
        add_edge!(graph, v, sat3.variable_count + v)
    end

    function variable(i, j)
        el = sat3.clauses[i, j]
        return if el < 0
            abs(el) + sat3.variable_count
        else
            el
        end
    end

    for i in axes(sat3.clauses, 1)
        first = elementsCounter += 1
        second = elementsCounter += 1
        third = elementsCounter += 1

        # we add edges between elements in clauses

        add_edge!(graph, first, second)
        add_edge!(graph, second, third)
        add_edge!(graph, third, first)

        #we connect clause elements to their corresponding variables

        add_edge!(graph, first, variable(i, 1))
        add_edge!(graph, second, variable(i, 2))
        add_edge!(graph, third, variable(i, 3))

    end

    # we compute the size of vertex cover that we seek

    vcSize = sat3.variable_count + 2 * size(sat3.clauses, 1)

    return VertexCover(graph, vcSize)

end

function extract(solution::VertexCoverSolution, instance::SAT3)
    return SAT3Solution([in(v, solution.cover) for v in 1:(instance.variable_count)])
end

"""
conversion of 3SATSolution to VertexCoverSolution problem
"""
function construct(target::Type{VertexCoverSolution}, solution::SAT3Solution, sat3::SAT3)

    # vertex x corresponds to variable x in 3sat
    # vertex sat3.variable_count + x correspontd to ¬x
    # vertex 2*sat3.variable_count + 3*(i-1) + (j-1) corresponds to element j of clause i

    elementsCounter = 2 * sat3.variable_count

    vars = map(((num, eval),) -> if eval
            num
        else
            sat3.variable_count + num
        end, enumerate(solution.evaluation))

    cover = Set(vars)

    function eval(i, j)
        el = sat3.clauses[i, j]
        return if el < 0
            !solution.evaluation[-el]
        else
            solution.evaluation[el]
        end
    end

    for i in axes(sat3.clauses, 1)
        first = elementsCounter += 1
        second = elementsCounter += 1
        third = elementsCounter += 1

        if eval(i, 1)
            push!(cover, second, third)
        elseif eval(i, 2)
            push!(cover, first, third)
        else
            push!(cover, first, second)
        end

    end

    return VertexCoverSolution(cover)

end

# function construct(solution::SAT3Solution, problem::VertexCover)
#     n = length(solution.evaluation)
#     vars = []

#     if typeof(problem.record[1]) != sat3_vc
#         return Nothing
#     end

#     for x in axes(solution.evaluation, 1)
#         if solution.evaluation[x]
#             push!(vars, x)
#         else
#             push!(vars, n + x)
#         end
#     end

#     cover = Set(vars)

#     clauses_num = (nv(problem.graph) - 2 * n - 1) / 2

#     done = Set()

#     for v in vars
#         # println(neighbors(problem.graph, v))
#         for clause in neighbors(problem.graph, v)

#             if clause <= 2 * n
#                 continue
#             end

#             cl_num = fld(clause - (2 * n + 1), 3)

#             if cl_num in done
#                 continue
#             else
#                 push!(done, cl_num)
#             end

#             for cl_el in neighbors(problem.graph, clause)
#                 if cl_el != v
#                     push!(cover, cl_el)
#                 end
#             end

#             if length(done) == clauses_num
#                 return VertexCoverSolution(cover)
#             end

#         end
#     end

#     return VertexCoverSolution(cover)
# end
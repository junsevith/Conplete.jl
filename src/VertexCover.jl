struct VertexCover
  graph::SimpleGraph
  size::UInt
end


"""
conversion of 3SAT to VertexCover problem
"""
function VertexCover(sat3::SAT3)

    # vertex x corresponds to variable x in 3sat
    # vertex 2x correspontd to ¬x
    # vertex 2*sat3.variable_count + 3*(i-1) + (j-1) corresponds to element j of clause i

    graph = SimpleGraph(sat3.variable_count * 2 + length(sat3.clauses))

    elementsCounter = 2 * sat3.variable_count
    # we add edge between variable and its negation

    for v in 1:sat3.variable_count
        add_edge!(graph, v, 2 * v)
    end

    function variable(i, j)
        el = sat3.clauses[i, j]
        return if el < 0
            abs(el) * 2
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
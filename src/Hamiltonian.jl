struct HamiltonianCircuit
    graph::SimpleDiGraph
end

mutable struct VariableSubgraph
    start::UInt
    finish::UInt
    left::Array{UInt,1}
    right::Array{UInt,1}
    leftCounter::UInt
    rightCounter::UInt
    VariableSubgraph() = new(0, 0, [], [], 0, 0)
end

function HamiltonianCircuit(sat3::SAT3)

    graph = SimpleDiGraph(6 * size(sat3.clauses, 1))

    variableSubgraphs = [VariableSubgraph() for _ in 1:sat3.variable_count]

    vertCounter = 6 * size(sat3.clauses, 1)

    function connect_detour(inV::UInt, outV::UInt, varSg::Int)
        varSg = variableSubgraphs[abs(varSg)]

        # when variable is first used we create initial subgraph
        if varSg.start == 0
            add_vertices!(graph, 5)
            varSg.start = vertCounter += 1
            push!(varSg.left, vertCounter += 1, vertCounter += 1)
            push!(varSg.right, vertCounter += 1, vertCounter += 1)
            varSg.leftCounter = 1
            varSg.rightCounter = 1

            add_edge!(graph, varSg.start, varSg.left[1])
            add_edge!(graph, varSg.start, varSg.right[1])

            add_edge!(graph, varSg.left[1], varSg.right[1])
            add_edge!(graph, varSg.right[1], varSg.left[1])

            add_edge!(graph, varSg.left[1], varSg.right[2])
            add_edge!(graph, varSg.right[1], varSg.left[2])

            add_edge!(graph, varSg.left[2], varSg.right[2])
            add_edge!(graph, varSg.right[2], varSg.left[2])
        end

        subgLen = length(varSg.left)

        # we have not enough vertices in subgraph
        if subgLen == max(varSg.rightCounter, varSg.leftCounter)
            add_vertices!(graph, 2)
            push!(varSg.left, vertCounter += 1)
            push!(varSg.right, vertCounter += 1)

            subgLen += 1

            add_edge!(graph, varSg.left[subgLen-1], varSg.right[subgLen])
            add_edge!(graph, varSg.right[subgLen-1], varSg.left[subgLen])

            add_edge!(graph, varSg.left[subgLen], varSg.right[subgLen])
            add_edge!(graph, varSg.right[subgLen], varSg.left[subgLen])
        end

        #we connect variable subgraph with clause subgraph
        if var > 0
            add_edge!(graph, varSg.right[varSg.rightCounter], inV)
            add_edge!(graph, outV, varSg.left[varSg.rightCounter+1])

            varSg.rightCounter += 1
        else
            add_edge!(graph, varSg.left[varSg.rightCounter], inV)
            add_edge!(graph, outV, varSg.right[varSg.rightCounter+1])

            varSg.leftCounter += 1
        end



    end

    for i in axes(sat3.clauses, 1)
        in1 = (i - 1) * 6 + 1
        in2 = in1 + 1
        in3 = in1 + 2

        out1 = in1 + 3
        out2 = in1 + 4
        out3 = in1 + 5

        add_edge!(graph, in1, in2)
        add_edge!(graph, in2, in3)
        add_edge!(graph, in3, in1)

        add_edge!(graph, in1, out1)
        add_edge!(graph, in2, out2)
        add_edge!(graph, in3, out3)

        add_edge!(graph, out3, out2)
        add_edge!(graph, out2, out1)
        add_edge!(graph, out1, out3)

        connect_detour(in1, out1, sat3.clauses[i, 1])
        connect_detour(in2, out2, sat3.clauses[i, 2])
        connect_detour(in3, out3, sat3.clauses[i, 3])
    end

    prevEnd = 0

    for varSg in variableSubgraphs
        if varSg.start != 0
            add_vertex!(graph)
        end
        
    end

end
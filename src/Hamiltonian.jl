using DataStructures

struct HamiltonianCircuit
    graph::SimpleDiGraph
end

function HamiltonianCircuit(sat3::SAT3)

    variables = 1:sat3.variable_count

    #Count how many vertices do we need to initialize the graph
    countp = [0 for _ in variables]
    countn = [0 for _ in variables]

    for i in axes(sat3.clauses, 1), j in 1:3
        el = sat3.clauses[i, j]
        if el < 0
            countn[-el] += 1
        else
            countp[el] += 1
        end
    end

    vertex_count = size(sat3.clauses, 1)

    for i in variables
        max_v = max(countn[i], countp[i])
        if max_v > 0
            vertex_count += 3 * max_v + 3
        end
    end

    #initialization
    g = SimpleDiGraph(vertex_count)

    posq = [Queue{UInt}() for _ in variables]
    negq = [Queue{UInt}() for _ in variables]
    start = [0 for _ in variables]

    vertex_counter = 0

    function next_slot(var, qs, qs2)
        q = qs[var]
        q2 = qs2[var]
        len = length(q)

        #we initialize the variable subgraph
        if len == 0
            a = vertex_counter += 1
            b = vertex_counter += 1
            c = vertex_counter += 1

            start[var] = a
            push!(q, c)
            push!(q2, c)

            add_edge!(g, a, b)
            add_edge!(g, b, c)
            add_edge!(g, c, b)
            add_edge!(g, b, a)
        end

        #variable subgraph is too short
        if len < 3
            #we add 3 more vertices
            a = vertex_counter += 1
            b = vertex_counter += 1
            c = vertex_counter += 1

            #vertex c will not be used now so we put it in queue
            #vertex a will be used now for slot so there is no point in putting it in queue
            push!(q, c)

            push!(q2, a)
            push!(q2, c)

            #there always has to be a at least one vertex in subgraph at this point
            s = popfirst!(q)

            #we add connection between edges
            add_edge!(g, s, a)
            add_edge!(g, a, b)
            add_edge!(g, b, c)
            add_edge!(g, c, b)
            add_edge!(g, b, a)
            add_edge!(g, a, s)

            return (s, a)
        else
            #queue has enough vertices so we just pop two
            s = popfirst!(q)
            f = popfirst!(q)
            return (s, f)
        end

    end

    #we add clauses 
    for i in axes(sat3.clauses, 1)
        clause_vertex = vertex_counter += 1
        for j in 1:3
            var = sat3.clauses[i, j]

            #we connect clauses to variables
            s = Nothing
            f = Nothing
            if var < 0
                (f, s) = next_slot(-var, negq, posq)
            else
                (s, f) = next_slot(var, posq, negq)
            end

            add_edge!(g, s, clause_vertex)
            add_edge!(g, clause_vertex, f)
        end
    end

    bb = 0 # beginning before
    eb = 0 # end before

    bf = 0 # beginning first
    ef = 0 # end first

    #we connect variable subgraphs together
    for i in variables
        b = start[i]

        #we skip variable if it doesnt have any vertices
        if b > 0
            e = if length(posq[i]) == 1
                popfirst!(posq[i])
            else #one of the queues always has to have length 1
                popfirst!(negq[i])
            end

            #first variable
            if bf == 0
                bf = b
                ef = e

                bb = b
                eb = e
            else
                add_edge!(g, bb, b)
                add_edge!(g, bb, e)
                add_edge!(g, eb, b)
                add_edge!(g, eb, e)

                bb = b
                eb = e
            end
        end
    end

    #we connect first and last variable subgraph
    add_edge!(g, bb, bf)
    add_edge!(g, bb, ef)
    add_edge!(g, eb, bf)
    add_edge!(g, eb, ef)

    return HamiltonianCircuit(g)
end


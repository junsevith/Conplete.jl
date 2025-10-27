validate(solution::DirHamCycleSolution, problem::DirHamCycle) = validate_ham_cycle(solution.cycle, problem.graph)

function validate_ham_cycle(cycle::Vector{UInt}, graph::AbstractGraph)
    n = length(cycle)

    if n != nv(graph)
        return ErrorException("Invalid number of vertices in cycle")
    end

    if !all(x -> 0 < x <= n, cycle)
        return ErrorException("Invalid vertex in cycle")
    end

    if !allunique(cycle)
        return ErrorException("Vertex is traversed twice in cycle")
    end

    if !all(i -> has_edge(graph, i...), enumerate(cycle))
        return ErrorException("Cycle follows nonexistent edge")
    end

    return true

end

function needed_vertices(sat3::SAT3)
    #Count how many vertices do we need to initialize the graph

    #Count how many timex a variable has been used
    positive = zeros(UInt, sat3.variable_count)
    negative = zeros(UInt, sat3.variable_count)

    for i in axes(sat3.clauses, 1), j in 1:3
        el = sat3.clauses[i, j]
        if el < 0
            negative[-el] += 1
        else
            positive[el] += 1
        end
    end

    return size(sat3.clauses, 1) + 2 * sat3.variable_count + mapreduce((x, y) -> 3 * max(x, y) + 1, +, positive, negative)
end

function transform(sat3::SAT3, target::Type{DirHamCycle})
    variables = 1:sat3.variable_count

    vertices = needed_vertices(sat3)

    #initialization
    g = SimpleDiGraph{UInt}(vertices)

    posq = [Queue{UInt}() for _ in variables]
    negq = [Queue{UInt}() for _ in variables]

    vertex_counter = 2 * sat3.variable_count

    function next_slot(var, qs, qs2)
        q = qs[var]
        q2 = qs2[var]
        len = length(q)

        #we initialize the variable subgraph
        if len == 0
            a = var
            b = sat3.variable_count + var
            c = vertex_counter += 1

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
            s = 0
            f = 0
            if var < 0
                (f, s) = next_slot(-var, negq, posq)
            else
                (s, f) = next_slot(var, posq, negq)
            end

            add_edge!(g, s, clause_vertex)
            add_edge!(g, clause_vertex, f)
        end
    end

    ends = sizehint!(Vector{Tuple{UInt,UInt}}(), sat3.variable_count)

    remv = Vector{UInt}()

    # we find the ends for variable subgraphs
    for i in variables
        l = length(posq[i])

        #we skip variable if it doesnt have any vertices
        if l > 0
            e = if l == 1
                popfirst!(posq[i])
            else #one of the queues always has to have length 1
                popfirst!(negq[i])
            end

            push!(ends, (i, e))

        else
            # if variable doesnt have any uses we remove its vertices
            push!(remv, i, i + sat3.variable_count)
        end
    end

    push!(ends, ends[1])

    # we connect the ends together
    for ((pb, pe), (cb, ce)) in partition(ends, 2, 1)
        # pb .. pe
        # ↓ ⤩ ↓
        # cb .. ce
        add_edge!(g, pb, cb)
        add_edge!(g, pb, ce)
        add_edge!(g, pe, cb)
        add_edge!(g, pe, ce)
    end

    rem_vertex!.(Ref(g), remv)

    return DirHamCycle(g)
end

function extract(solution::DirHamCycleSolution, inst::SAT3)
    sec_rng = (x -> x+1:2x)(inst.variable_count)
    return SAT3Solution([x in sec_rng for x in Iterators.first(solution.cycle, inst.variable_count)])
end

function construct(target::Type{DirHamCycleSolution}, solution::SAT3Solution, sat3::SAT3)
    variables = 1:sat3.variable_count

    vertices = needed_vertices(sat3)

    #initialization
    sol = zeros(UInt, vertices)

    # clause_done = [false for _ in axes(sat3.clauses, 1)]

    posq = [Queue{UInt}() for _ in variables]
    negq = [Queue{UInt}() for _ in variables]

    vertex_counter = 2 * sat3.variable_count

    function next_slot(var, qs, qs2)
        q = qs[var]
        q2 = qs2[var]
        len = length(q)

        #we initialize the variable subgraph
        if len == 0
            a = var
            b = sat3.variable_count + var
            c = vertex_counter += 1

            push!(q, c)
            push!(q2, c)

            if solution.evaluation[var]
                sol[a] = b
                sol[b] = c
            else
                sol[c] = b
                sol[b] = a
            end
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
            if solution.evaluation[var]
                sol[s] = a
                sol[a] = b
                sol[b] = c
            else
                sol[c] = b
                sol[b] = a
                sol[a] = s
            end

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
        clause_done = false
        for j in 1:3
            var = sat3.clauses[i, j]

            #we connect clauses to variables
            s = 0
            f = 0
            if var < 0
                (f, s) = next_slot(-var, negq, posq)
            else
                (s, f) = next_slot(var, posq, negq)
            end

            # if clause hasnt been visited and variable negation matches evaluation
            # cycle by default skips the clause see above method next_slot
            if !clause_done && ((var > 0) == solution.evaluation[abs(var)])
                # We go to the clause
                sol[s] = clause_vertex
                sol[clause_vertex] = f

                clause_done = true
            end
        end
    end

    ends = sizehint!(Vector{Tuple{UInt,UInt}}(), sat3.variable_count)

    repl = Dict{UInt,UInt}()

    # we find the ends for variable subgraphs
    for i in variables
        l = length(posq[i])

        #we skip variable if it doesnt have any vertices
        if l > 0
            e = if l == 1
                popfirst!(posq[i])
            else #one of the queues always has to have length 1
                popfirst!(negq[i])
            end

            push!(ends, (i, e))

        else
            # if variable doesnt have any uses we remove its vertices
            push!(repl, length(sol) => i)
            push!(repl, length(sol) - 1 => i + sat3.variable_count)
        end
    end

    push!(ends, ends[1])

    # we connect the ends together
    for ((pb, pe), (cb, ce)) in partition(ends, 2, 1)
        # pb .. pe
        # ↓ ⤩ ↓
        # cb .. ce

        if solution.evaluation[pb] && solution.evaluation[cb]
            sol[pe] = cb
        elseif !solution.evaluation[pb] && solution.evaluation[cb]
            sol[pb] = cb
        elseif solution.evaluation[pb] && !solution.evaluation[cb]
            sol[pe] = ce
        else
            sol[pb] = ce
        end
    end

    foreach((k, v) -> sol[v] = sol[k], repl)

    resize!(sol, length(sol) - length(repl))

    replace!(sol, repl...)

    return DirHamCycleSolution(sol)
end
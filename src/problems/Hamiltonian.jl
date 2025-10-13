using DataStructures, IterTools

struct HamiltonianCycle <: NPProblem
    graph::SimpleDiGraph
    record::Array{TransformationRecord}
end

"""
Solution to a Hamiltonian-Cycle problem containing cycle in following format:

an array of length equal to number of vertices where value cycle[x] = y corresponds to edge (x,y) in cycle

"""
struct HamiltonianCycleSolution <: NPSolution
    cycle::Array{UInt}
end

function validate(solution::HamiltonianCycleSolution, problem::HamiltonianCycle)
    if length(solution.cycle) != nv(problem.graph)
        return false # ErrorException("invalid cycle length")
    end
    visited = [false for _ in vertices(problem.graph)]
    cur = 1
    visited[1] = true

    for _ in vertices(problem.graph)
        cur = solution.cycle[cur]

        if visited[cur]
            if cur == 1
                break # cycle finished
            else
                return false # ErrorException("vertex twice in cycle")
            end
        else
            visited[cur] = true
        end
    end



    if !all(visited)
        return false # ErrorException("Cycle is too short")
    else
        return true
    end

end

struct sat3_ham <: TransformationRecord
    variable_count::UInt
end

function needed_vertices(sat3::SAT3)
    variables = 1:sat3.variable_count

    #Count how many vertices do we need to initialize the graph

    #Count how many timex a variable has been used
    positive = [0 for _ in variables]
    negative = [0 for _ in variables]

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

function HamiltonianCycle(sat3::SAT3)
    variables = 1:sat3.variable_count

    vertices = needed_vertices(sat3)

    #initialization
    g = SimpleDiGraph(vertices)

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

    ends = []

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
            rem_vertex!(g, i)
            rem_vertex!(g, i + sat3.variable_count)
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

    return HamiltonianCycle(g, [sat3_ham(sat3.variable_count); sat3.record])
end

function extract(solution::HamiltonianCycleSolution, unpackData::sat3_ham)
    eval = [false for _ in 1:(unpackData.variable_count)]

    for v in 1:unpackData.variable_count
        if solution.cycle[v] == v + unpackData.variable_count
            eval[v] = true
        end
    end

    return SAT3Solution(eval)
end


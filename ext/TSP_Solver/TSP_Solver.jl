module TSP_Solver

using Conplete, Concorde, Graphs


function Conplete.solve(problem::HamCycle)
    edges = Matrix(adjacency_matrix(problem.graph))

    map!(x -> if x == 0 1 else 0 end, edges)

    @time (cycle, len) = solve_tsp(edges)

    # display(len)
    println(cycle)

    prev = cycle[1]
    cycle2 = [0 for _ in cycle]
    cycle2[last(cycle)] = prev
    for e in Iterators.drop(cycle, 1)
        cycle2[prev] = e
        prev = e
    end

    # println(cycle2)

    return HamCycleSolution(cycle2)
end
    
end
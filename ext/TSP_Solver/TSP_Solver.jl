module TSP_Solver

using Conplete, Concorde, Graphs


function Conplete.solve(problem::TSP)
    edges = problem.weights

    (cycle, len) = solve_tsp(edges)

    prev = cycle[1]
    cycle2 = [0 for _ in cycle]
    cycle2[last(cycle)] = prev
    for e in Iterators.drop(cycle, 1)
        cycle2[prev] = e
        prev = e
    end

    return TSPSolution(cycle2)
end
    
end
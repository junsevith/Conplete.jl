validate(sol::HamCycleSolution, problem::HamCycle) = validate_ham_cycle(sol.cycle, problem.graph)

function transform(parent::DirHamCycle, target::Type{HamCycle})
    n = nv(parent.graph)
    g = SimpleGraph{Int}(n * 3)

    # 1 - n   : input vertices
    # n - 2n  : middle vertices
    # 2n - 3n : output vertices
    for v in vertices(parent.graph)
        inp = v
        mid = v + n
        out = v + 2 * n

        add_edge!(g, inp, mid)
        add_edge!(g, mid, out)

        add_edge!.(Ref(g), out, neighbors(parent.graph, v))
    end

    return HamCycle(g)
end

function extract(sol::HamCycleSolution, parent::DirHamCycle)
    n = nv(parent.graph)

    return if sol.cycle[1] < 2 * n
        # Cycle goes in the right direction
        DirHamCycleSolution([sol.cycle[x+2*n] for x in vertices(parent.graph)])
    else
        # Cycle goes in the oposite direction
        cycle = zeros(Int, n)

        for x in vertices(parent.graph)
            out = sol.cycle[x] - 2 * n
            cycle[out] = x
        end

        DirHamCycleSolution(cycle)
    end
end

function construct(target::Type{HamCycleSolution}, solution::DirHamCycleSolution, parent::DirHamCycle)
    n = length(solution.cycle)

    return HamCycleSolution([
        if i <= 2 * n
            i + n
        else
            solution.cycle[i-2*n]
        end for i in 1:(3*n)
    ])
end
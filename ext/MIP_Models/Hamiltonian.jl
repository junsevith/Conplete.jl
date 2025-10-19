# Based on Dantzig–Fulkerson–Johnson MIP formulation of Travelling Salesman Problem with lazy subset constraints
# Modified version of https://jump.dev/JuMP.jl/stable/tutorials/algorithms/tsp_lazy_constraints/
# When solver supports it, model uses Solver-independent Callbacks https://jump.dev/JuMP.jl/stable/manual/callbacks/#callbacks_manual

function Conplete.solve(solver, problem::DirHamCycle)
    model = Model(solver)
    vert = vertices(problem.graph)
    n = nv(problem.graph)

    edges = adjacency_matrix(problem.graph)

    # display(edges)

    set_silent(model)
    @variable(model, e[i=vert, j=vert] <= edges[i, j], Bin)

    for v in vert
        @constraint(model, sum(e[v, :]) == 1)
        @constraint(model, sum(e[:, v]) == 1)
    end

    # We add constraints for cycles of length 2 manually because they appear to be too common
    # otherwise the callbacks slow down the solver immensely
    for i in vert
        for j in 1:(i-1)
            @constraint(model, e[i, j] + e[j, i] <= 1)
        end
    end

    @objective(model, Min, 1)

    # the solver may produce solutions consisting of several smaller cycles
    # so we lazily add constraints eliminating smaller cycles
    function subtour_elimination_callback(cb_data)
        status = callback_node_status(cb_data, model)
        if status != MOI.CALLBACK_NODE_STATUS_INTEGER
            return  # Only run at integer solutions
        end
        cycle = find_subtour(getcycle(callback_value.(cb_data, model[:e])))
        if !(1 < length(cycle) < n)
            return  # Only add a constraint if there is a cycle
        end
        println("Found cycle of length $(length(cycle))")
        S = [(i, j) for (i, j) in Iterators.product(cycle, cycle) if i != j]
        con = @build_constraint(
            sum(model[:e][i, j] for (i, j) in S) <= length(cycle) - 1,
        )
        MOI.submit(model, MOI.LazyConstraint(cb_data), con)
        return
    end
    set_attribute(
        model,
        MOI.LazyConstraintCallback(),
        subtour_elimination_callback,
    )


    callback = try
        optimize!(model)
        true
    catch
        @warn "For faster optimization this method requires solver that supports Solver-independent Callbacks"
        set_attribute(
            model,
            MOI.LazyConstraintCallback(),
            nothing,
        )
        optimize!(model)
        false
    end

    #fallback iterative approach for when callback are not supported by the solver
    if !callback
        cycle = find_subtour(getcycle(value(model[:e])))
        while 1 < length(cycle) < n
            println("Found cycle of length $(length(cycle))")
            S = [(i, j) for (i, j) in Iterators.product(cycle, cycle) if i != j]
            @constraint(
                model,
                sum(model[:e][i, j] for (i, j) in S) <= length(cycle) - 1,
            )
            optimize!(model)
            if !is_solved_and_feasible(model)
                break
            end
            cycle = find_subtour(getcycle(value(model[:e])))
        end
    end

    if is_solved_and_feasible(model)
        return DirHamCycleSolution(getcycle(value(e)))
    else
        return nothing
    end
end


function getcycle(val)
    cycle = [0 for _ in axes(val, 1)]
    for i in axes(val, 1), j in axes(val, 2)
        if val[i, j] > 0.5
            cycle[i] = j
        end
    end

    return cycle
end

function find_subtour(cycle::Vector{Int})
    shortest_subtour, unvisited = collect(eachindex(cycle)), Set(eachindex(cycle))
    while !isempty(unvisited)
        this_cycle, neighbors = Int[], unvisited
        while !isempty(neighbors)
            current = pop!(neighbors)
            push!(this_cycle, current)
            if length(this_cycle) > 1
                pop!(unvisited, current)
            end
            neighbors = if cycle[current] in unvisited
                [cycle[current]]
            else
                []
            end
        end
        if length(this_cycle) < length(shortest_subtour)
            shortest_subtour = this_cycle
        end
    end
    # println(shortest_subtour)
    return shortest_subtour
end
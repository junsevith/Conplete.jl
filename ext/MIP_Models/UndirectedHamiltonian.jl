# Based on Dantzig–Fulkerson–Johnson MIP formulation of Travelling Salesman Problem with lazy subset constraints
# Modified version of https://jump.dev/JuMP.jl/stable/tutorials/algorithms/tsp_lazy_constraints/
# When solver supports it, model uses Solver-independent Callbacks https://jump.dev/JuMP.jl/stable/manual/callbacks/#callbacks_manual

function Conplete.solve(model::Model, problem::HamCycle)
    vert = vertices(problem.graph)

    n = nv(problem.graph)

    edges = adjacency_matrix(problem.graph)

    # display(edges)

    @variable(model, e[i=vert, j=vert] <= edges[i, j], Bin)
    @constraint(model, [i in vert, j in (i+1):n], e[i, j] == e[j, i])
    @constraint(model, [v in vert], sum(e[v, :]) == 2)
    @constraint(model, [v in vert], sum(e[:, v]) == 2)
    @constraint(model, [i in vert], e[i, i] == 0)
    @objective(model, Min, 1)

    # the solver may produce solutions consisting of several smaller cycles
    # so we lazily add constraints eliminating smaller cycles
    function subtour_elimination_callback(cb_data)
        status = callback_node_status(cb_data, model)
        if status != MOI.CALLBACK_NODE_STATUS_INTEGER
            return  # Only run at integer solutions
        end
        cycle = find_subtour(getcycle_undir(callback_value.(cb_data, model[:e])))
        if !(1 < length(cycle) < n)
            return  # Only add a constraint if there is a cycle
        end
        # println("Callback found cycle of length $(length(cycle))")
        S = [(i, j) for (i, j) in Iterators.product(cycle, cycle) if i < j]
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

    #fallback iterative approach for when callbacks are not supported by the solver
    if !callback
        cycle = find_subtour(getcycle_undir(value(model[:e])))
        while 1 < length(cycle) < n
            # println("Callback found cycle of length $(length(cycle))")
            S = [(i, j) for (i, j) in Iterators.product(cycle, cycle) if i < j]
            @constraint(
                model,
                sum(model[:e][i, j] for (i, j) in S) <= length(cycle) - 1,
            )
            optimize!(model)
            if !is_solved_and_feasible(model)
                break
            end
            cycle = find_subtour(getcycle_undir(value(model[:e])))
        end
    end

    if is_solved_and_feasible(model)
        return HamCycleSolution(getcycle_undir(value(e)))
    else
        return nothing
    end
end


function getcycle_undir(val)
    cycle = [0 for _ in axes(val, 1)]

    for i in axes(val, 1)
        if cycle[i] == 0
            prev = 0
            cur = i
            for _ in axes(val, 1)
                # println(cur)
                for v in axes(val, 1)
                    if v != prev && val[cur, v] > 0.5
                        cycle[cur] = v
                        prev = cur
                        cur = v
                        break
                    end
                end

                if cur == i
                    break
                end
            end
        end
    end

    # println(cycle)

    return cycle
end
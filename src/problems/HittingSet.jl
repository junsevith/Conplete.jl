function validate(sol::HittingSetSolution, inst::HittingSet)
    return if length(sol.hitting_set) > inst.size
        ErrorException("solution too large")
    else
        all(x -> any(y -> y ∈ sol.hitting_set, x), inst.sets)
    end
end

function transform(parent::VertexCover, target::Type{HittingSet})
    return HittingSet(nv(parent.graph), [Set{Int}([src(e), dst(e)]) for e in edges(parent.graph)], parent.size)
end

function extract(sol::HittingSetSolution, parent::VertexCover)
    return VertexCoverSolution(sol.hitting_set)
end

function construct(target::Type{HittingSetSolution}, sol::VertexCoverSolution, parent::VertexCover)
    return HittingSetSolution(sol.cover)
end
# Library interfaces

```@docs
transform(instance::NPProblem, target_type::Type{<:NPProblem})
```

```@docs
transform(instance::NPProblem, chain_path::Vector{Type{<:NPProblem}})
```

```@docs
chain_transform(instance::NPProblem, target_type::Type{<:NPProblem})
```

```@docs
chain_transform(instance::NPProblem, chain_path::Vector{Type{<:NPProblem}})
```

```@docs
extract(solution::NPSolution, chain::Vector{NPProblem})
```

```@docs
construct(solution::NPSolution, chain::Vector{NPProblem})
```

```@docs
construct(target::Type{NPSolution}, solution::NPSolution, problem::NPProblem)
```

```@docs
solve
```
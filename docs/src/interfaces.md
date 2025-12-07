# Library interfaces

Library utilizes two sets of interfaces for two distinct use cases.

For simple reductions regular interfaces can be used

```@docs
transform(instance::NPProblem, target_type::Type{<:NPProblem})
```

```@docs
transform(instance::NPProblem, chain_path::Vector{Type{<:NPProblem}})
```

```@docs
extract
```

```@docs
construct
```

```@docs
solve
```

## Chain reductions

It is possible to perform reductions that chain several reduction algorithms, when performing such reductions you should use interfaces described below.

When performing problem instance transformation you can also use regular `transform` function, but for solution transformations chain functions are mandatory

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




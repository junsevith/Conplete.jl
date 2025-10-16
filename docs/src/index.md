# Conplete.jl Documentation

```@docs
transform(instance::NPProblem, target_type::Type{<:NPProblem})
```

```@docs
transform(instance::NPProblem, chain_path::Vector{DataType})
```

```@docs
chain_transform(instance::NPProblem, target_type::Type{<:NPProblem})
```

```@docs
chain_transform(instance::NPProblem, chain_path::Vector{DataType})
```

```@docs
extract(solution::NPSolution, chain::Array{NPProblem})
```

```@docs
construct(solution::NPSolution, chain::Array{NPProblem})
```

```@docs
construct(target::Type{NPSolution}, solution::NPSolution, problem::NPProblem)
```

```@docs
solve
```

```@docs
add_problem(inst::Type{<:NPProblem}, solution::Type{<:NPSolution})
```

```@docs
add_transformation(new::Type{<:NPProblem}, parent::Type{<:NPProblem})
```
# Conplete.jl Documentation

**Conplete** is a library for Julia janguage implementing polynomial reductions for several NP-Complete problems. It utilizes interfaces described in the document below

Full list of structures describing problem instances implemented in library can be found in [this page](structures.md).

Library allows for extending its functionality by the user, which is described in [this page](extending.md)

Library was created for a master's thesis of Paweł Stanik in Wrocław university of science and technology.

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
``
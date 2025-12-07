# Adding problems and reductions

It is possible to dymanically extend library's functionality with your own types and methods. Note that types sould be subtypes of `NPProblem` or `NPSolution` defined in library, and methods should abide by the interfaces defined in library, see [interfaces](interfaces.md)


```@docs
add_problem(inst::Type{<:NPProblem}, solution::Type{<:NPSolution})
```

```@docs
add_transformation(new::Type{<:NPProblem}, parent::Type{<:NPProblem})
```

```@docs
solution_type(prob::Type{<:NPProblem})
```

```@docs
problem_type(prob::Type{<:NPSolution})
```
function Base.show(io::IO, obj::NPProblem)
    str = "Instance of problem " * string(typeof(obj))
    print(io, str)
end
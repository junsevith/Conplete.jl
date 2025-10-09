push!(LOAD_PATH,"../src/")

using Documenter, Conplete

makedocs(sitename="Conplete.jl", remotes = nothing)

deploydocs(
    repo = "github.com/junsevith/Conplete.jl.git",
)
push!(LOAD_PATH,"../src/")

using Documenter, Conplete

makedocs(
    sitename="Conplete.jl", 
    pages = [
       "Home" => "index.md",
       "Interfaces" => "interfaces.md",
       "Problems" => "structures.md",
       "Adding reductions" => "extending.md"
    ])

deploydocs(
    repo = "github.com/junsevith/Conplete.jl.git",
)
module MIP_Models

using Conplete
using JuMP
using Graphs

include("SAT3.jl")
include("VertexCover.jl")
include("Hamiltonian.jl")
include("Clique.jl")
include("UndirectedHamiltonian.jl")
include("SubsetSum.jl")
include("CNFSAT.jl")
include("HittingSet.jl")
include("Partition.jl")
include("BinPacking.jl")

end
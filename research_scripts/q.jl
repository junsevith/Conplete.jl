using DataStructures

x = PriorityQueue()
push!(x, 1 => 5)

y = popfirst!(x).first
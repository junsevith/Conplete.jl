using Conplete

struct Pies <: Problem
    dums::UInt64
end

struct Kot
    smart::UInt64
end

function Pies(inst::SAT3)
    return Pies(1)
end

add_problem(Pies) == 12

# @test_throws MethodError add_problem(Kot)

add_transformation(Pies, SAT3)

add_transformation(Pies, VertexCover)

println(methods(Pies))
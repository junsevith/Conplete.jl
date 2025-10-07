using Conplete

struct data1 <: UnpackData 
    d::Int
end

struct data2 <: UnpackData 
    e::UInt
end

struct data3 <: UnpackData 
    e::UInt
end

struct data4 <: UnpackData 
    e::UInt
end

function data2(a::data3)
    return data2(a.e)
end

function data1(a::data4)
    return data1(a.e)
end



struct cont 
    araj::Array{UnpackData}
end

x = cont([data1(3),data2(5),data3(7)])

function pies(a::data1)
    println("asdasd")
end

function pies(a::data2)
   println("zxczxczx") 
end

function pies(a::UnpackData)
    pies(data2(a)) 
end

function process(c::cont)
    for d in c.araj
        pies(d)
    end
end

d = Dict(data1 => 1, data2 => 2)


process(x)


d[data2]
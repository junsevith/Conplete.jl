using Conplete

struct data1 <: UnpackData 
    d::Int
end

struct data2 <: UnpackData 
    e::UInt
end

struct cont 
    araj::Array{UnpackData}
end

x = cont([data1(3),data2(5)])

function pies(a::data1)
    println("asdasd")
end

function pies(a::data2)
   println("zxczxczx") 
end

function process(c::cont)
    for d in c.araj
        pies(d)
    end
end


process(x)
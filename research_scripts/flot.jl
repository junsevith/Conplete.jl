
let i = 1


    for z in 1:100
        f = Float64(i)
        println(z)
        println(BigFloat(f))
        println(i)
        println(Int(f))
        if Int(f) != i
            break
        end
        i = 2i + 1
    end

end
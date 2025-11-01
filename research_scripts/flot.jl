
let i = 1
    f = Float64(1)

    for z in 1:100
        println(z)
        println(BigFloat(f))
        println(i)
        println(Int(f))
        if Int(f) != i
            display(i - 1)
            break
        end
        i *= 2
        f *= 2
    end

end
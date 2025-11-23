function _safehalf(i::T) where T <: Integer
    v, r = divrem(i, 2)
    if r == 1
        throw(ErrorException("Value is not divisible by 2"))
    end
    return v
end
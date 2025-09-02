struct SAT3
  variable_count::UInt
  clauses::Matrix{Int}
end

# finde the variable count of given clauses
function SAT3(clauses::Matrix{Int})
    max = 0

    for i in axes(clauses, 1), j in 1:3
        max = max(max, abs(clauses[i,j]))
    end

    return SAT3(max, clauses)
end
function unpack(solution::Solution, reductionData::Array{UnpackData}, depth::UInt)
    unpacked = solution
    for d in reductionData
        if depth == 0
            return unpacked
        end

        unpacked = unpackSolution(solution, d)
    end

    return unpacked
end

unpack(solution::Solution, reductionData::Array{UnpackData}) = unpack(solution, reductionData, typemax(UInt))

unpack(solution::HamiltonianSolution, problem::HamiltonianCircuit, depth::UInt) = unpack(solution, problem.unpack_data, depth)
unpack(solution::VertexCoverSolution, problem::VertexCover, depth::UInt) = unpack(solution, problem.unpack_data, depth)


unpack(solution::Solution, problem::Problem) = unpack(solution, problem, typemax(UInt))

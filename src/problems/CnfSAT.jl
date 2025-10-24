struct CNFSAT <: NPProblem
        variable_count::UInt
    clauses::Array{Array{Int}}
end

struct CNFSATSolution <: NPSolution
  evaluation::BitArray
end

function CNFSAT(clauses::Vector{Vector{Int}})
  maxi = 0

  for clause in clauses, v in clause
    maxi = max(maxi, abs(v))
  end

  return CNFSAT(maxi, clauses)
end

function validate(solution::CNFSATSolution, problem::CNFSAT)
  if length(solution.evaluation) != problem.variable_count
    return ErrorException("Invalid solution size")
  end

  return all(y -> any(x -> x < 0 ? !solution.evaluation[-x] : solution.evaluation[x], y), problem.clauses)
end
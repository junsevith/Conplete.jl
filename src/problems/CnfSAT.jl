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

function transform(inst::SAT3, target::Type{CNFSAT})
  return CNFSAT(inst.variable_count, eachrow(inst.clauses))
end

function extract(sol::CNFSATSolution, parent::SAT3)
  return SAT3Solution(sol.evaluation)
end

function construct(target::Type{CNFSATSolution}, sol::SAT3Solution, parent::Union{SAT3,Nothing}=nothing)
  return CNFSATSolution(sol.evaluation)
end
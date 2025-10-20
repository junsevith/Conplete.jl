struct SAT3 <: NPProblem
  variable_count::UInt
  clauses::Matrix{Int}
end

struct SAT3Solution <: NPSolution
  evaluation::BitArray
end

# find the variable count of given clauses
function SAT3(clauses::Matrix{Int})
  maxi = 0

  for i in axes(clauses, 1), j in 1:3
    maxi = max(maxi, abs(clauses[i, j]))
  end

  return SAT3(maxi, clauses)
end


function SAT3(path::String)
  file = open(path, "r")

  m = Matrix{Int}
  vars = UInt
  currow = 1

  for line in readlines(file)
    if line[1] == 'c'
      #nothing
    elseif line[1] == 'p'
      args = split(strip(line))
      vars = parse(UInt, args[3])
      matlen = parse(UInt, args[4])
      m = [0 for i in 1:matlen, j in 1:3]
    elseif line[1] == '%'
      break
    else
      args = split(strip(line))
      args = [parse(Int, x) for x in args[1:3]]
      m[currow, 1:3] = [args[1], args[2], args[3]]
      currow += 1
    end
  end

  return SAT3(vars, m)
end

function validate(solution::SAT3Solution, problem::SAT3)
  if length(solution.evaluation) != problem.variable_count
    return false
  end

  return all(y -> any(x -> x < 0 ? !solution.evaluation[-x] : solution.evaluation[x], y), eachrow(problem.clauses))
end
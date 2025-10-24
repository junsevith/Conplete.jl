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

  for v in clauses
    maxi = max(maxi, abs(v))
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
    return ErrorException("Invalid solution size")
  end

  return all(y -> any(x -> x < 0 ? !solution.evaluation[-x] : solution.evaluation[x], y), eachrow(problem.clauses))
end

function transform(parent::CNFSAT, target::Type{SAT3})
  cnt = parent.variable_count
  vars = Matrix[]
  sizehint!(vars, parent.variable_count)

  cnt::Int = parent.variable_count

  for clause in parent.clauses
    len = length(clause)

    mat = if len == 1
      el = clause[1]
      x = cnt += 1
      y = cnt += 1

      [
        el x y
        el -x y
        el x -y
        el -x -y
      ]
    elseif len == 2
      el = clause[1]
      el2 = clause[2]
      x = cnt += 1

      [
        el el2 x
        el el2 -x
      ]
    elseif len == 3
      clause'
    else
      m = zeros(Int, len - 2, 3)
      x = cnt += 1

      m[1, :] = Int[clause[1] clause[2] x]

      for v in 3:(len-2)
        y = cnt += 1
        m[v-1, :] = Int[-x clause[v] y]
        x = y
      end

      m[len-2, :] = Int[-x clause[len-1] clause[len]]

      m
    end

    push!(vars, mat)
  end

  return SAT3(cnt, vcat(vars...))

end

function extract(sol::SAT3Solution, parent::CNFSAT)
  return CNFSATSolution(sol.evaluation[1:parent.variable_count])
end

function construct(target::Type{SAT3Solution}, sol::CNFSATSolution, parent::CNFSAT)
  cnt = parent.variable_count
  vars = BitArray[]
  sizehint!(vars, parent.variable_count)

  push!(vars, sol.evaluation)

  cnt::Int = parent.variable_count

  eval(x::Int) = x > 0 ? sol.evaluation[x] : !sol.evaluation[-x]

  for clause in parent.clauses
    len = length(clause)

    mat = if len == 1
      cnt += 2

      [0, 0]
    elseif len == 2
      cnt += 1

      [0]
    elseif len == 3
      []
    else
      m = falses(len - 3)
      cnt += 1

      prev = !(eval(clause[1]) || eval(clause[2]))
      m[1] = prev

      for v in 3:(len-2)
        y = cnt += 1
        prev = !(eval(clause[v]) || !prev)
        m[v-1] = prev
      end

      m
    end

    push!(vars, mat)
  end

  return SAT3Solution(vcat(vars...))
end
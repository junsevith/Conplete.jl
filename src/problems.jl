struct SAT3
  variable_count::UInt
  clauses::Matrix{Int}
end

struct VertexCover
  graph::SimpleGraph
  size::UInt
end
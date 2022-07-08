mutable struct Edge{T}
  vertex::T
  weight::Number

  Edge(vertex::T) where T = new{T}(vertex, 0)
  Edge(vertex::T, weight::Number) where T = new{T}(vertex, weight)
end

show(io::IO, edge::Edge) = begin
  print(io, edge.vertex)
  print(io, " ", edge.weight)
  print(io, " ", "|")
end
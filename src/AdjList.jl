mutable struct AdjList{T}
  vertex::T
  edges::List{Edge{T}}
end

show(io::IO, adjlist::AdjList) = begin
  println(io)
  print(io, adjlist.vertex)
  print(io, "----|")

  for edge in adjlist.edges
    print(io, edge, " ")
  end

  
end
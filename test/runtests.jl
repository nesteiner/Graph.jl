using Graph, Test

@testset "test graph" begin
  graph = DirectedGraph(Int)

  for i in 1:4
    insertVertex!(graph, i)
  end

  insertEdge!(graph, 1, 2)
  insertEdge!(graph, 1, 3)
  insertEdge!(graph, 2, 4)
  
  println(graph)


  # removeEdge!(graph, 2, 4)
  # println(graph)

  removeVertex!(graph, 2)
  println(graph)
end
using Graph, Test

@testset "test graph" begin

  @testset "test graph1" begin
    graph = DirectedGraph(Int)

    for i in 1:4
      insertVertex!(graph, i)
    end

    insertEdge!(graph, 1, 2)
    insertEdge!(graph, 1, 3)
    insertEdge!(graph, 1, 4)
    insertEdge!(graph, 2, 4)
    insertEdge!(graph, 3, 4)
    println(graph)


    # removeEdge!(graph, 2, 4)
    # println(graph)

    # removeVertex!(graph, 2)
    # println(graph)

    println("test1")

    for value in bfsiterate(graph)
      println(value)
    end

    println()
  end

  @testset "test graph2" begin
    graph = DirectedGraph(Int)

    for i in 1:5
      insertVertex!(graph, i)
    end

    insertEdge!(graph, 1, 2)
    insertEdge!(graph, 1, 3)
    insertEdge!(graph, 2, 4)
    insertEdge!(graph, 3, 4)
    insertEdge!(graph, 2, 5)
    insertEdge!(graph, 4, 5)

    println("test2")
    for value in bfsiterate(graph)
      println(value)
    end

    println()
  end

  @testset "test graph3" begin
    graph = DirectedGraph(Int)
    insertVertex!(graph, 1)
    insertVertex!(graph, 2)

    insertEdge!(graph, 1, 2)
    insertEdge!(graph, 2, 1)

    println("test3")
    count = 1
    for value in bfsiterate(graph)
      if count == 100
        break
      end
      
      println(value)
      count += 1
    end

    println()
  end

  @testset "test graph dfs" begin
    graph = DirectedGraph(Int)

    for i in 1:6
      insertVertex!(graph, i)
    end

    insertEdge!(graph, 1, 2)
    insertEdge!(graph, 2, 4)
    insertEdge!(graph, 2, 5)
    insertEdge!(graph, 1, 3)
    insertEdge!(graph, 3, 6)

    insertEdge!(graph, 5, 6)
    insertEdge!(graph, 6, 5)

    println("test4")

    for value in dfsiterate(graph)
      println(value)
    end

    println()
  end

end
module Graph
using LinkedList
import Base.:(==)
import Base: show, iterate

include("Edge.jl")
include("AdjList.jl")

mutable struct DirectedGraph{T}
  vertexCount::Int
  edgeCount::Int
  adjlists::List{AdjList{T}}

  DirectedGraph(E::DataType) = new{E}(0, 0, List(AdjList{E}))
end

#=
1. insert vertex
2. insert edge
3. remove vertex
4. remove edge
5. bfs iterate
6. dfs iterate

7. vertex count
8. edge count
=#

function findEdges(graph::DirectedGraph{T}, vertex::T) where T
  node = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  if !isnothing(node)
    return dataof(node).edges
  else
    return List(Edge{T})
  end
end

function insertVertex!(graph::DirectedGraph{T}, data::T) where T
  adjlist = AdjList{T}(data, List(Edge{T}))
  push!(graph.adjlists, adjlist)
  graph.vertexCount += 1
end

function insertEdge!(graph::DirectedGraph{T}, vertex::T, otherVertex::T, weight::Number = 0) where T
  nodeLeft = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  nodeRight = findfirst(adjlist -> adjlist.vertex == otherVertex, graph.adjlists)

  if isnothing(nodeLeft) || isnothing(nodeRight)
    throw("cannot insert edge on non-exist vertex")
  else
    # pushnext!(graph.adjlists, node1, Edge(otherVertex, weight))
    push!(dataof(nodeLeft).edges, Edge(otherVertex, weight))
    graph.edgeCount += 1
  end
end

function removeVertex!(graph::DirectedGraph{T}, vertex::T) where T
  node = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  if isnothing(node)
    throw("cannot delete on a non-exist vertex")
  else
    popat!(graph.adjlists, node)
    graph.vertexCount -= 1

    for adjlist in graph.adjlists
      edges = adjlist.edges
      _node = findfirst(edge -> edge.vertex == vertex, edges)
      if !isnothing(_node)
        popat!(edges, _node)

        graph.vertexCount -= 1
      end
    end
  end
end

function removeEdge!(graph::DirectedGraph{T}, vertex::T, otherVertex::T) where T
  nodeLeft = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  nodeRight = findfirst(adjlist -> adjlist.vertex == otherVertex, graph.adjlists)

  if isnothing(nodeLeft) || isnothing(nodeRight)
    throw("cannot delete edge on a non-exist vertex")
  else
    edges = findEdges(graph, vertex)
    node = findfirst(edge -> edge.vertex == otherVertex, edges)

    if !isnothing(node)
      popat!(edges, node)

      graph.edgeCount -= 1
    else
      throw("cannot delete edge on a non-exist vertex")
    end
  end
end

vertexCount(graph::DirectedGraph) = graph.vertexCount
edgeCount(graph::DirectedGraph) = graph.edgeCount


export DirectedGraph
export insertVertex!, insertEdge!, removeVertex!, removeEdge!, vertexCount, edgeCount
end # module
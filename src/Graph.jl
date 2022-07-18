module Graph
using LinkedList
import Base.:(==)
import Base: show, iterate

include("Edge.jl")
include("AdjList.jl")

abstract type AbstractGraph{T} end
mutable struct DirectedGraph{T} <: AbstractGraph{T}
  vertexCount::Int
  edgeCount::Int
  adjlists::List{AdjList{T}}

  DirectedGraph(E::DataType) = new{E}(0, 0, List(AdjList{E}))
end

mutable struct UnDirectedGraph{T} <: AbstractGraph{T}
  vertexCount::Int
  edgeCount::Int
  adjlists::List{AdjList{T}}

  UnDirectedGraph(E::DataType) = new{E}(0, 0, List(AdjList{E}))
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
9. replace weight
10. replace vertex
11.find weight

=#

function findEdges(graph::AbstractGraph{T}, vertex::T) where T
  node = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  if !isnothing(node)
    return dataof(node).edges
  else
    return List(Edge{T})
  end
end

function insertVertex!(graph::AbstractGraph{T}, data::T) where T
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
    edges = dataof(nodeLeft).edges
    node = findfirst(edge -> edge.vertex == otherVertex, edges)
    if isnothing(node)
      push!(dataof(nodeLeft).edges, Edge(otherVertex, weight))
      graph.edgeCount += 1
    end
  end
end

function insertEdge!(graph::UnDirectedGraph{T}, vertex::T, otherVertex::T, weight::Number = 0) where T
  nodeLeft = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  nodeRight = findfirst(adjlist -> adjlist.vertex == otherVertex, graph.adjlists)

  if isnothing(nodeLeft) || isnothing(nodeRight)
    throw("cannot insert edge on non-exist vertex")
  else

    edges = dataof(nodeLeft).edges
    node = findfirst(edge -> edge.vertex == otherVertex, edges)

    if isnothing(node)
      len = length(edges)
      push!(edges, Edge(otherVertex, weight))
      @assert length(edges) == len + 1 "push edge error"
    end

    edges = dataof(nodeRight).edges
    node = findfirst(edge -> edge.vertex == vertex, edges)

    if isnothing(node)
      len = length(edges)
      push!(edges, Edge(vertex, weight))
      @assert length(edges) == len + 1 "push edge error"
    end


    graph.edgeCount += 1
  end
end

function removeVertex!(graph::AbstractGraph{T}, vertex::T) where T
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

function removeEdge!(graph::UnDirectedGraph{T}, vertex::T, otherVertex::T) where T
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

    edges = findEdges(graph, otherVertex)
    node = findfirst(edge -> edge.vertex == vertex, edges)

    if !isnothing(node)
      popat!(edges, node)
      
      graph.edgeCount -= 1
    else
      throw("cannot delete edge on a non-exist vertex")
    end

  end
end

vertexCount(graph::AbstractGraph) = graph.vertexCount
edgeCount(graph::AbstractGraph) = graph.edgeCount

function replaceWeight!(graph::DirectedGraph{T}, vertex::T, otherVertex::T, weight::Number) where T
  nodeLeft = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  nodeRight = findfirst(adjlist -> adjlist.vertex == otherVertex, graph.adjlists)

  if isnothing(nodeLeft) || isnothing(nodeRight)
    throw("cannot replace weight on a non exists vertex")
  else
    edges = findEdges(graph, vertex)
    node = findfirst(edge -> edge.vertex == otherVertex, edges)
    if !isnothing(node)
      dataof(node).weight = weight
    else
      throw("there is no edge between these two vertex")
    end
  end
end

function replaceWeight!(graph::UnDirectedGraph{T}, vertex::T, otherVertex::T, weight::Number) where T
  nodeLeft = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  nodeRight = findfirst(adjlist -> adjlist.vertex == otherVertex, graph.adjlists)

  if isnothing(nodeLeft) || isnothing(nodeRight)
    throw("cannot replace weight on a non exists vertex")
  else
    edges = findEdges(graph, vertex)
    node = findfirst(edge -> edge.vertex == otherVertex, edges)
    if !isnothing(node)
      dataof(node).weight = weight
    else
      throw("there is no edge between these two vertex")
    end

    edges = findEdges(graph, otherVertex)
    node = findfirst(edge -> edge.vertex == vertex, edges)
    if !isnothing(node)
      dataof(node).weight = weight
    else
      throw("there is no edge between these two vertex")
    end

  end
end

function replaceVertex!(graph::AbstractGraph{T}, vertex::T, otherVertex::T) where T
  node = findfirst(adjlist -> adjlist.vertex == vertex, graph.adjlists)
  
  if isnothing(node)
    throw("cannot replace on a non-exist vertex")
  else
    dataof(node).vertex = otherVertex

    for adjlist in graph.adjlists
      edges = adjlist.edges
      _node = findfirst(edge -> edge.vertex == vertex, edges)

      if !isnothing(_node)
        dataof(_node).vertex = otherVertex
      end
    end
  end
end

function iscyclicutil(graph::AbstractGraph{T}, start::T, visited::Dict{T, Bool}, parent::Union{T, Nothing}) where T
  visited[start] = true
  for edge in findEdges(graph, start)
    if !visited[edge.vertex]
      if iscyclicutil(graph, edge.vertex, visited, start)
        return true
      end
    elseif !isnothing(edge.vertex) && edge.vertex != parent
      return true
    end
  end

  return false
end

function hascycle(graph::AbstractGraph{T}) where T
  visited = Dict{T, Bool}()

  for adjlist in graph.adjlists
    visited[adjlist.vertex] = false
  end

  for adjlist in graph.adjlists
    vertex = adjlist.vertex

    if !visited[vertex]
      if iscyclicutil(graph, vertex, visited, nothing)
        return true
      end
    end
  end
  
  return false
end

include("Iterate.jl")
bfsiterate(graph::AbstractGraph{T}) where T = BFSIterator(graph, nothing)
dfsiterate(graph::AbstractGraph{T}) where T = DFSIterator(graph, nothing)
bfsiterate(graph::AbstractGraph{T}, start::T) where T = begin
  node = findfirst(adjlist -> adjlist.vertex == start, graph.adjlists)
  isnothing(node) && throw("cannot iterate from an non-exist vertex")

  return BFSIterator(graph, dataof(node))
end

dfsiterate(graph::AbstractGraph{T}, start::T) where T = begin
  node = findfirst(adjlist -> adjlist.vertex == start, graph.adjlists)
  isnothing(node) && throw("cannot iterate from an non-exist vertex")

  return DFSIterator(graph, dataof(node))
end

export DirectedGraph, UnDirectedGraph
export insertVertex!, insertEdge!, removeVertex!, removeEdge!, vertexCount, edgeCount, replaceWeight!, replaceVertex!, bfsiterate, dfsiterate
export hascycle
end # module

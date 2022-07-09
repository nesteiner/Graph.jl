mutable struct BFSIterator{T}
  graph::DirectedGraph{T}
end

@enum Color begin
  White
  Grey
  Black
end

mutable struct BFSState{T}
  queue::Queue{T}
  visited::Dict{T, Color}
end

function iterate(iterator::BFSIterator{T}) where T
  state = BFSState{T}(Queue(T), Dict{T, Color}())

  for adjlist in iterator.graph.adjlists
    vertex = adjlist.vertex
    state.visited[vertex] = White
  end

  if vertexCount(iterator.graph) == 0
    return nothing
  end

  firstVertex = first(iterator.graph.adjlists).vertex
  state.visited[firstVertex] = Black
  edges = findEdges(iterator.graph, firstVertex)
  
  for edge in edges
    push!(state.queue, edge.vertex)
    state.visited[edge.vertex] = Grey
  end

  return firstVertex, state
end

function iterate(iterator::BFSIterator{T}, state::BFSState{T}) where T
  isempty(state.queue) && return nothing

  vertex = first(state.queue)
  pop!(state.queue)

  if state.visited[vertex] != Black
    edges = findEdges(iterator.graph, vertex)

    for edge in edges
      if state.visited[edge.vertex] == White
        push!(state.queue, edge.vertex)
        
        state.visited[edge.vertex] = Grey
      end
    end

    state.visited[vertex] = Black
  end

  return vertex, state
  
end
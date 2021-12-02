defmodule StlInsight.Ascii.Loop do
  @moduledoc """
  Representation of a Loop, being a collection of 3 Vertexes. Largely irrelevant, included here to handle edge case of a facet with multiple loops
  """
  alias StlInsight.Ascii.Vertex
  alias StlInsight.Ascii.Facet

  @doc """
  ## Examples

      iex> StlInsight.Ascii.Loop.new("   outer loop\n    vertex 0.360463 0 2.525\n    vertex 0 0 2.98309\n    vertex 0.360463 0.2 2.525\n   endloop")
      %{v1: %Vertex{}, v2: %Vertex{}, v3: %Vertex{}}

  """
  def new(loop) do
    loop
    |> String.trim()
    |> String.split("\n")
    |> build_loop
  end

  defp build_loop([_, v1, v2, v3, _]) do
    %Facet{
      v1: v1 |> fetch_vertex,
      v2: v2 |> fetch_vertex,
      v3: v3 |> fetch_vertex
    }
  end

  defp fetch_vertex(vertex) do
    Vertex.new(vertex)
    |> check_vertex
  end

  defp check_vertex({:ok, vertex}), do: vertex
  defp check_vertex({:error, error}), do: raise(error)
end

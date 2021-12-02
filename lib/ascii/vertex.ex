defmodule StlInsight.Ascii.Vertex do
  @moduledoc """
  Representation of a Vertex, being a list of 3 Coordinates in 3d space
  """
  defstruct x: nil, y: nil, z: nil

  alias StlInsight.Ascii.Vertex

  @doc """
  ## Examples

      iex> StlInsight.Ascii.Vertex.new("vertex 0 0 2.98309")
      {:ok, %Vertex{x: 0, y: 0, z: 2.98309}}


  """
  def new(vertex) do
    vertex
    |> String.trim()
    |> String.split()
    |> map_vertex()
  end

  defp map_vertex(["vertex", x, y, z]) do
    {:ok,
     %Vertex{
       x: x |> string_to_int_or_float(),
       y: y |> string_to_int_or_float(),
       z: z |> string_to_int_or_float()
     }}
  end

  defp map_vertex(_) do
    {:error, "invalid vertex"}
  end

  defp string_to_int_or_float(string) do
    string_to_int_or_float(string, String.contains?(string, "."))
  end

  defp string_to_int_or_float(string, true) do
    String.to_float(string)
  end

  defp string_to_int_or_float(string, false) do
    String.to_integer(string)
  end
end

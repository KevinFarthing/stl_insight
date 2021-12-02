defmodule StlInsight.Ascii.Facet do
  @moduledoc """
  Representation of a Facet, being a triangular face containing x loops of 3 vertexes
  To keep variable loops consistent with binary files, a facet containing multiple loops will return multiple facets instead
  """
  alias StlInsight.Ascii.Vertex
  alias StlInsight.Ascii.Facet
  alias StlInsight.Ascii.Loop
  # defstruct v1: %Vertex{}, v2: %Vertex{}, v3: %Vertex{}, significand: {0, 0, 0}
  defstruct v1: %Vertex{}, v2: %Vertex{}, v3: %Vertex{}

  @doc """
  ## Examples

    StlInsight.Ascii.Facet.new("  facet normal -0.785875 0 -0.618385 \nouter loop\nendloop\nendfacet")
    [%Facet{v1: %Vertex{}, v2: %Vertex{}, v3: %Vertex{}}]

    StlInsight.Ascii.Facet.new("  facet normal -0.785875 0 -0.618385 \nouter loop\nendloop\nouter loop\nendloop\nendfacet")
    [%Facet{v1: %Vertex{}, v2: %Vertex{}, v3: %Vertex{}}, %Facet{v1: %Vertex{}, v2: %Vertex{}, v3: %Vertex{}}]

  """
  def new(facet) do
    Regex.scan(~r/(?s)loop.*?endloop/, facet)
    |> Enum.map(fn [loop] -> Loop.new(loop) end)
  end

  def area(%Facet{v1: v1, v2: v2, v3: v3}) do
    # https://www.youtube.com/watch?v=MnpaeFPyn1A
    # calculate vectors
    # find cross product
    # find magnitude

    vector1_2 = %{x: v2.x - v1.x, y: v2.y - v1.y, z: v2.z - v1.z}
    vector1_3 = %{x: v3.x - v1.x, y: v3.y - v1.y, z: v3.z - v1.z}

    determinant1 = vector1_2.y * vector1_3.z - vector1_2.z * vector1_3.y
    determinant2 = vector1_2.x * vector1_3.z - vector1_2.z * vector1_3.x
    determinant3 = vector1_2.x * vector1_3.y - vector1_2.y * vector1_3.x

    {determinant1, determinant2, determinant3}
    |> get_magnitude()
    |> Kernel./(2)

    # rounding at this step removed
    # rounding should always be done after all calculations have been complete
    # ie upon final solid struct, or after measuring area of the set of facets
    # |> Float.round(4)
  end

  defp get_magnitude({d1, d2, d3}) do
    :math.sqrt(:math.pow(d1, 2) + :math.pow(d2, 2) + :math.pow(d3, 2))
  end
end

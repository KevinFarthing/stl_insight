defmodule StlInsight do
  @moduledoc """
  Documentation for `StlInsight`.
  """

  alias StlInsight.Ascii.Solid

  @doc """
  Calculates features and complexity of a given STL file

  ## Examples

      iex> StlInsight.examine("moon.stl")
      "Number of Triangles: 116
      Surface Area: 7.7726"

  """
  def examine(filename) do
    solid =
      File.read!("priv/images/#{filename}")
      |> parse_stl
  end

  def parse_stl(stl) do
    case String.contains?(stl, "solid") and String.contains?(stl, "endsolid") do
      true ->
        Solid.new(stl)

      false ->
        {:error, "stl is binary encoded"}
    end
  end
end

defmodule StlInsight.Ascii.Solid do
  @moduledoc """
  Representation of a Solid, being a collection facets forming a full 3d image
  """

  alias StlInsight.Ascii.Solid
  alias StlInsight.Ascii.Facet

  defstruct area: 0, triangles_count: 0, facets: []

  def new(data) do
    data = Regex.scan(~r/(?s)facet.*?endfacet/, data)

    Enum.reduce(data, %Solid{}, fn [facet], solid ->
      facets = Facet.new(facet)
      facets_area = Enum.reduce(facets, 0, fn facet, area -> area + Facet.area(facet) end)

      %Solid{
        facets: solid.facets ++ facets,
        triangles_count: solid.triangles_count + (facets |> length),
        area: solid.area + facets_area
      }
    end)
  end
end

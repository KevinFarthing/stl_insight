defmodule StlInsight.Ascii.Solid do
  @moduledoc """
  Representation of a Solid, being a collection facets forming a full 3d image
  """

  alias StlInsight.Ascii.Solid
  alias StlInsight.Ascii.Facet

  defstruct area: 0, triangles_count: 0, facets: []

  def new(data) do
    data = Regex.scan(~r/(?s)facet.*?endfacet/, data)

    solid =
      Enum.reduce(data, %Solid{}, fn [facet], solid ->
        facets = Facet.new(facet)

        # Enum.reduce(facets, 0, fn facet, area -> Float.round(area + Facet.area(facet), 4) end)
        facets_area = Enum.reduce(facets, 0, fn facet, area -> area + Facet.area(facet) end)

        %Solid{
          facets: solid.facets ++ facets,
          triangles_count: solid.triangles_count + (facets |> length),
          area: solid.area + facets_area
          # area: Float.round(solid.area + facets_area, 4)
        }
      end)

    area = solid.area |> Float.round(4)

    %{solid | area: area}
  end
end

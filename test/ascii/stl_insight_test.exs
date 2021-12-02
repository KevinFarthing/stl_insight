defmodule StlInsightTest do
  use ExUnit.Case
  #   doctest StlInsight

  alias StlInsight.Ascii.{Facet, Loop, Solid, Vertex}

  @sample_stl """
  solid simplePart
    facet normal 0 0 0
        outer loop
            vertex 0 0 0
            vertex 1 0 0
            vertex 1 1 1
        endloop
    endfacet
    facet normal 0 0 0
        outer loop
            vertex 0 0 0
            vertex 0 1 1
            vertex 1 1 1
        endloop
    endfacet
  endsolid simplePart
  """

  @sample_stl_triangles_count 2
  @sample_stl_area 1.4142

  test "area and triangles from raw ascii" do
    parsed_stl = StlInsight.parse_stl(@sample_stl)
    assert parsed_stl.triangles_count == @sample_stl_triangles_count
    assert parsed_stl.area == @sample_stl_area
  end

  test "area and triangles from moon.stl" do
    parsed_stl = File.read!("priv/images/moon.stl") |> StlInsight.parse_stl()
    assert parsed_stl.triangles_count == 116
    assert parsed_stl.area == 7.7726
  end

  test "create vertex" do
    v = Vertex.new("\n            vertex 0 1 2\n")
    assert v == {:ok, %Vertex{x: 0, y: 1, z: 2}}
  end

  test "facet area calculation" do
    facet1 = %Facet{
      v1: %Vertex{x: 0, y: 0, z: 0},
      v2: %Vertex{x: 1, y: 0, z: 0},
      v3: %Vertex{x: 1, y: 1, z: 1}
    }

    facet2 = %Facet{
      v1: %Vertex{x: 0, y: 0, z: 0},
      v2: %Vertex{x: 0, y: 1, z: 1},
      v3: %Vertex{x: 1, y: 1, z: 1}
    }

    assert Float.round(Facet.area(facet1) + Facet.area(facet2), 4) == @sample_stl_area
  end

  test "facet area calculation youtube" do
    facet = %StlInsight.Ascii.Facet{
      v1: %StlInsight.Ascii.Vertex{x: -5, y: 5, z: -5},
      v2: %StlInsight.Ascii.Vertex{x: 1, y: -6, z: 6},
      v3: %StlInsight.Ascii.Vertex{x: 2, y: -3, z: 4}
    }

    assert Facet.area(facet) |> Float.round(4) == 19.3067
  end

  test "facet area calculation advanced" do
    facet = %StlInsight.Ascii.Facet{
      v1: %StlInsight.Ascii.Vertex{x: 0.360463, y: 0, z: 2.525},
      v2: %StlInsight.Ascii.Vertex{x: 0, y: 0, z: 2.98309},
      v3: %StlInsight.Ascii.Vertex{x: 0.360463, y: 0.2, z: 2.525}
    }

    assert Facet.area(facet) |> Float.round(4) == 0.0583
  end

  #   test "examine" do
  #     StlInsight.examine("moon.stl")
  #   end
end

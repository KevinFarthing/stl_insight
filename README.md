# StlInsight

StlInsight is a tool to parse stl files and determine the complixity of the model

## Installation

```elixir
def deps do
  [
    {:stl_insight, "~> 0.1.0"}
  ]
end
```

## Usage

.stl files should be saved to the `priv/images` folder
Once there, start the application with `iex -S mix`
and run

```
iex> StlInsight.examine("moon.stl")
```

Which will generate the area and the number of triangles as

```
Number of Triangles: 116
Surface Area: 7.7726
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/stl_insight](https://hexdocs.pm/stl_insight).

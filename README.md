# xmerl_xml_indent

A callback module to write XML with indentation for Elixir.

As the module name suggests, this library must be used in conjunction with Erlang's built-in `xmerl` library.

Erlang's `xmerl` library lacks the module to export XML with indentation. This library provides an alternative callback module to `xmerl_xml`.

## Installation

Add `xmerl_xml_indent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xmerl_xml_indent, "~> 0.1.0"}
  ]
end
```

## Usage


```elixir
xml_str = "<?xml version = \"1.0\"?><Level1><Level2><Level3A>This is level 3</Level3A><Level3B>This is level 3B</Level3B><Level3C><Level4>This is level 4</Level4><Level4B><Level5>This is level 5</Level5></Level4B></Level3C></Level2></Level1>"

xml_chars = String.to_charlist(xml_str)
{xml_parsed, _} = :xmerl_scan.string(xml_chars)
xml_exported = :xmerl.export([xml_parsed], XmerlXmlIndent)
to_string(xml_exported)
```

The above code produces XML output:

```xml
<?xml version="1.0"?>
<Level1>
  <Level2>
    <Level3A>This is level 3A</Level3A>
    <Level3B>This is level 3B</Level3B>
    <Level3C>
      <Level4>This is level 4</Level4>
      <Level4B>
        <Level5>This is level 5</Level5>
      </Level4B>
    </Level3C>
  </Level2>
</Level1>
```

## Limitations

1. This module indent XML with 2 spaces. This is not configurable
2. This module indent XML with LF (`\n`) only. This is not configurable

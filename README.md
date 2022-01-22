# xmerl_xml_indent
A callback module to write XML with indentation for Elixir

How to use:

```elixir
xml_str = "<?xml version = \"1.0\"?><Level1><Level2><Level3A>This is level 3</Level3A><Level3B>This is level 3B</Level3B><Level3C><Level4>This is level 4</Level4><Level4B><Level5>This is level 5</Level5></Level4B></Level3C></Level2></Level1>"

xml_chars = String.to_charlist(xml_str)
{xml_parsed, _} = :xmerl_scan.string(xml_chars)
xml_exported = :xmerl.export([xml_parsed], :xmerl_xml_indent)
to_string(xml_exported)
```

Using `:xmerl_xml_indent` as the callback will indent the XML output:

```xml
<?xml version=\"1.0\"?>
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
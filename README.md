# xmerl_xml_indent

Erlang OTP's built-in `xmerl` module lacks the functionality to print XML with indentation. This module is an alternative to `xmerl_xml` to print XML with indentation.

This module is taken from https://github.com/erlang/otp/blob/master/lib/xmerl/src/xmerl_xml.erl, converted to Elixir and modified for indentation.

As the module name suggests, this library must be used in conjunction with Erlang's built-in `xmerl` library.

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

## Customizing End of Line (EOL) and Indent characters

`XmerlXmlIndent` uses LF (`\n`) as the EOL character and two spaces as the indent.

If you want to customize this behavior, you can create a custom module. For example:

```elixir
defmodule XmerlXmlIndentCustom do
  use XmerlXmlIndentBase

  def new_line() do
    "\r\n"
  end

  def indent() do
    "\t"
  end
end
```

defmodule XmerlXmlIndentCustom do
  use XmerlXmlIndentBase

  def new_line() do
    "NEW_LINE"
  end

  def indent() do
    "INDENT"
  end
end

defmodule CustomizationTest do
  use ExUnit.Case

  @correct_simple "<?xml version=\"1.0\"?>NEW_LINE
<Level1>NEW_LINE
INDENT<Level2>NEW_LINE
INDENTINDENT<Level3A>This is level 3A</Level3A>NEW_LINE
INDENTINDENT<Level3B>This is level 3B</Level3B>NEW_LINE
INDENTINDENT<Level3C>NEW_LINE
INDENTINDENTINDENT<Level4>This is level 4</Level4>NEW_LINE
INDENTINDENTINDENT<Level4B>NEW_LINE
INDENTINDENTINDENTINDENT<Level5>This is level 5</Level5>NEW_LINE
INDENTINDENTINDENT</Level4B>NEW_LINE
INDENTINDENT</Level3C>NEW_LINE
INDENT</Level2>NEW_LINE
</Level1>"

  def export_indented(xml_str) do
    xml_chars = String.to_charlist(xml_str)
    {xml_parsed, _} = :xmerl_scan.string(xml_chars)
    xml_exported = :xmerl.export([xml_parsed], XmerlXmlIndentCustom)
    to_string(xml_exported)
  end

  test "Indenting one line" do
    xml_str =
      "<?xml version = \"1.0\"?><Level1><Level2><Level3A>This is level 3A</Level3A><Level3B>This is level 3B</Level3B><Level3C><Level4>This is level 4</Level4><Level4B><Level5>This is level 5</Level5></Level4B></Level3C></Level2></Level1>"

    xml_exported_str = export_indented(xml_str)
    assert xml_exported_str == String.replace(@correct_simple, "\n", "")
  end
end

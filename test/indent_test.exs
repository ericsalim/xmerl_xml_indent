defmodule IndentTest do
  use ExUnit.Case

  @correct_simple "<?xml version=\"1.0\"?>
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
</Level1>"

  @correct_soap "<?xml version=\"1.0\"?>
<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope/\" soap:encodingStyle=\"http://www.w3.org/2003/05/soap-encoding\">
  <soap:Body>
    <m:GetPriceResponse xmlns:m=\"https://www.w3schools.com/prices\">
      <m:Price>1.90</m:Price>
    </m:GetPriceResponse>
  </soap:Body>
</soap:Envelope>"

  def export_indented(xml_str) do
    xml_chars = String.to_charlist(xml_str)
    {xml_parsed, _} = :xmerl_scan.string(xml_chars)
    xml_exported = :xmerl.export([xml_parsed], XmerlXmlIndent)
    to_string(xml_exported)
  end

  def normalize_new_lines(xml_str) do
    String.replace(xml_str, "\r\n", "\n")
  end

  test "Indenting one line" do
    xml_str = "<?xml version = \"1.0\"?><Level1><Level2><Level3A>This is level 3A</Level3A><Level3B>This is level 3B</Level3B><Level3C><Level4>This is level 4</Level4><Level4B><Level5>This is level 5</Level5></Level4B></Level3C></Level2></Level1>"

    xml_exported_str = export_indented(xml_str)
    correct_simple_lf = normalize_new_lines(@correct_simple)

    assert xml_exported_str == correct_simple_lf
  end

  test "Test indenting multiple lines without indent" do
    xml_str = "<?xml version = \"1.0\"?>
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
</Level1>"

    xml_exported_str = export_indented(xml_str)
    correct_simple_lf = normalize_new_lines(@correct_simple)

    assert xml_exported_str == correct_simple_lf
  end

  test "Test indenting an already indented XML" do
    xml_str = "<?xml version=\"1.0\"?>
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
</Level1>"

    xml_exported_str = export_indented(xml_str)
    correct_simple_lf = normalize_new_lines(@correct_simple)

    assert xml_exported_str == correct_simple_lf
  end

  test "Test indenting ugly XML" do
    xml_str = "<?xml version=\"1.0\"?>
<Level1>
  <Level2>
    <Level3A>This is level 3A</Level3A>
<Level3B>This is level 3B</Level3B>
    <Level3C>
<Level4>This is level 4</Level4>
      <Level4B>
        <Level5>This is level 5</Level5>
      </Level4B></Level3C></Level2></Level1>"

    xml_exported_str = export_indented(xml_str)
    correct_simple_lf = normalize_new_lines(@correct_simple)

    assert xml_exported_str == correct_simple_lf
  end

  test "Test indenting SOAP XML (with namespaces)" do
    xml_str = "<?xml version=\"1.0\"?><soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope/\" soap:encodingStyle=\"http://www.w3.org/2003/05/soap-encoding\"><soap:Body><m:GetPriceResponse xmlns:m=\"https://www.w3schools.com/prices\"><m:Price>1.90</m:Price></m:GetPriceResponse></soap:Body></soap:Envelope>"

    xml_exported_str = export_indented(xml_str)
    correct_soap_lf = normalize_new_lines(@correct_soap)

    assert xml_exported_str == correct_soap_lf
  end
end

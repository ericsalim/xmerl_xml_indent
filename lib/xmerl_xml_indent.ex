defmodule :xmerl_xml_indent do
  @moduledoc """
  Erlang OTP's built-in `xmerl` library lacks functionality to print XML with indent.
  This module fills the gap by providing a custom callback to print XML with indent.
  This module is taken from https://github.com/erlang/otp/blob/master/lib/xmerl/src/xmerl_xml.erl,
  converted to Elixir and modified for indentation.
  """

  def unquote(:"#xml-inheritance#")() do
    []
  end

  def unquote(:"#text#")(text) do
    :xmerl_lib.export_text(text)
  end

  def unquote(:"#root#")(data, [%{name: _, value: v}], [], _e) do
    [v, data]
  end

  def unquote(:"#root#")(data, _attrs, [], _e) do
    ["<?xml version=\"1.0\"?>\n", data]
  end

  def unquote(:"#element#")(tag, [], attrs, _parents, _e) do
    :xmerl_lib.empty_tag(tag, attrs)
  end

  def unquote(:"#element#")(tag, data, attrs, parents, _e) do
    data =
      cond do
        is_a_tag?(data) ->
          level = Enum.count(parents)

          data
          |> clean_up_tag()
          |> indent_tag_lines(level)

        true ->
          data
      end

    :xmerl_lib.markup(tag, attrs, data)
  end

  @doc """
  This function distinguishes XML tag from XML value.

  Let's say there's an XML tag `<Outer><Inner>Value</Inner></Outer>`,
  then there will be two calls to this function:
  1. The first call will have `data` parameter `['Value']`
  2. The second call will have `data` parameter
     `[[['<', 'Inner', '>'], ['Value'], ['</', 'Inner', '>']]]`

  The first one is not a tag, but a value.
  The second one is a tag.
  """
  def is_a_tag?(data) do
    is_all_chars =
      Enum.reduce(
        data,
        true,
        fn d, acc ->
          is_char = is_integer(Enum.at(d, 0))
          acc && is_char
        end)

    !is_all_chars
  end

  @doc """
  This function cleans up tag contaminated by characters outside the tag.

  Example: If the tag is indented, then remove the new lines
  ```
  [
    '\n        ',
    [['<', 'Tag', '>'], ['Value'], ['</', 'Tag', '>']],
    '\n      '
  ]
  ```

  The cleaned up tag should look like this:
  ```
  [[['<', 'Tag', '>'], ['Value'], ['</', 'Tag', '>']]]
  ```
  """
  def clean_up_tag(data) do
    Enum.filter(
      data,
      fn d -> !is_integer(Enum.at(d, 0)) end)
  end

  @doc """
  This function indents all tag lines

  Example clean data:
  ```
  [
    [['<', 'Tag1', '>'], ['Value 1'], ['</', 'Tag1', '>']],
    [['<', 'Tag2', '>'], ['Value 2'], ['</', 'Tag2', '>']],
  ]
  ```

  Then this function interleaves the elements with new lines and appends
  a new line with one lower level indent:
  ```
  [
    ['\n  ']
    ['<', 'Tag1', '>'],
    ['Value 1'],
    ['</', 'Tag1', '>'],
    ['\n  ']
    ['<', 'Tag2', '>'],
    ['Value 2'],
    ['</', 'Tag2', '>'],
    ['\n']
  ]
  ```
  """
  def indent_tag_lines(data, level) do
    indented =
      Enum.reduce(
        data,
        [],
        fn d, acc ->
          acc ++ [prepend_indent(level + 1)] ++ d
        end)

    indented ++ [prepend_indent(level)]
  end

  def prepend_indent(level) do
    ("\n" <> String.duplicate("  ", level)) |> to_charlist()
  end
end

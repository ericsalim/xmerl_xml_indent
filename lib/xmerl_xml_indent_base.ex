defmodule XmerlXmlIndentBase do
  @moduledoc """
  Erlang OTP's built-in `xmerl` library lacks functionality to print XML with indent.
  This module fills the gap by providing a custom callback to print XML with indent.

  This module is taken from https://github.com/erlang/otp/blob/master/lib/xmerl/src/xmerl_xml.erl,
  converted to Elixir and modified for indentation.

  This module is used in conjunction with Erlang's `xmerl` library. See the project documentation for details.
  """

  defmacro __using__(_opts) do
    quote do
      def new_line() do
        "\n"
      end

      def indent() do
        "  "
      end

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
        ["<?xml version=\"1.0\"?>#{new_line()}", data]
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

      # This function distinguishes an XML tag from an XML value.

      # Let's say there's an XML string `<Outer><Inner>Value</Inner></Outer>`,
      # there will be two calls to this function:
      # 1. The first call has `data` parameter `['Value']`
      # 2. The second call has `data` parameter
      #    `[[['<', 'Inner', '>'], ['Value'], ['</', 'Inner', '>']]]`

      # The first one is an XML value, not an XML tag.
      # The second one is an XML tag.

      defp is_a_tag?(data) do
        is_all_chars =
          Enum.reduce(
            data,
            true,
            fn d, acc ->
              is_char = is_integer(Enum.at(d, 0))
              acc && is_char
            end
          )

        !is_all_chars
      end

      # This function cleans up a tag data contaminated by characters outside the tag.

      # If the tag data is indented, this function removes the new lines
      # ```
      # [
      #   '\\n        ',
      #   [['<', 'Tag', '>'], ['Value'], ['</', 'Tag', '>']],
      #   '\\n      '
      # ]
      # ```

      # After the cleanup, the tag data looks like this:
      # ```
      # [[['<', 'Tag', '>'], ['Value'], ['</', 'Tag', '>']]]
      # ```

      defp clean_up_tag(data) do
        Enum.filter(
          data,
          fn d -> !is_integer(Enum.at(d, 0)) end
        )
      end

      # This function indents all tag lines in the data.

      # Example clean tag data:
      # ```
      # [
      #   [['<', 'Tag1', '>'], ['Value 1'], ['</', 'Tag1', '>']],
      #   [['<', 'Tag2', '>'], ['Value 2'], ['</', 'Tag2', '>']],
      # ]
      # ```

      # This function interleaves the tag data with indented new lines and appends
      # a new line with one lower level indent:
      # ```
      # [
      #   ['\\n  ']
      #   ['<', 'Tag1', '>'],
      #   ['Value 1'],
      #   ['</', 'Tag1', '>'],
      #   ['\\n  ']
      #   ['<', 'Tag2', '>'],
      #   ['Value 2'],
      #   ['</', 'Tag2', '>'],
      #   ['\\n']
      # ]
      # ```

      defp indent_tag_lines(data, level) do
        indented =
          Enum.reduce(
            data,
            [],
            fn d, acc ->
              acc ++ [prepend_indent(level + 1)] ++ d
            end
          )

        indented ++ [prepend_indent(level)]
      end

      defp prepend_indent(level) do
        (new_line() <> String.duplicate(indent(), level)) |> to_charlist()
      end

      defoverridable new_line: 0, indent: 0
    end
  end
end

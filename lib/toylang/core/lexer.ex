defmodule Toylang.Core.Lexer do
  # Example source code:
  #
  # def greet do
  #   return "Hello!"
  # end
  #
  # def give_me_a_number do
  #   return 42
  # end
  def get_tokens(input) do
    tokenize(input |> String.graphemes, "", [])
  end

  defp tokenize([], current_token, tokens) do
    tokens ++ finalize_token(current_token)
  end

  defp tokenize([char | rest], current_token, tokens) do
    case char do
      # If we encounter a space, we finalize the current token
      "" ->
        tokens ++ finalize_token(current_token)

      " " when current_token != "" ->
        tokenize(rest, "", tokens ++ finalize_token(current_token))

      " " ->
        tokenize(rest, current_token, tokens)

      "\n" ->
        tokenize(rest, "", tokens ++ finalize_token(current_token))

      "\t" ->
        tokenize(rest, "", tokens ++ finalize_token(current_token))

      _ ->
        if letter_or_digit?(char) do
          tokenize(rest, current_token <> char, tokens)
        else
          tokenize(rest, "", tokens ++ finalize_token(char))
        end
    end
  end

  defp letter_or_digit?(char) do
    char =~ ~r/[a-zA-Z0-9]/
  end

  defp finalize_token(""), do: [{:eof, "eof"}]
  defp finalize_token(chars) do
    token = to_string(chars)
    case token do
      "def" -> [{:method_def, token }]
      "do" -> [{:method_open, token }]
      "end" -> [{:method_close, token }]
      "return" -> [{:method_ret, token}]
      _ -> [{:identifier, token}]
    end
  end
end



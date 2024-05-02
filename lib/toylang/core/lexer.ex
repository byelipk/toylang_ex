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
  #
  # var ten = 10
  def get_tokens(input) do
    tokenize(input |> String.graphemes, "", [])
  end

  defp tokenize([], "", tokens) do
    tokens ++ finalize_token("")
  end

  defp tokenize([], current_token, tokens) do
    tokens ++ finalize_token(current_token) ++ finalize_token("")
  end

  defp tokenize([char | rest], current_token, tokens) do
    case char do
      "\s" when current_token != "" ->
        new_tokens = tokens ++ finalize_token(current_token)
        tokenize(rest, "", new_tokens)

      "\s" ->
        tokenize(rest, current_token, tokens)

      "\n" ->
        new_tokens = tokens ++ finalize_token(current_token)
        tokenize(rest, "", new_tokens)

      "\t" ->
        new_tokens = tokens ++ finalize_token(current_token)
        tokenize(rest, "", new_tokens)

      _ ->
        cond do
          is_letter?(char) -> 
            tokenize(rest, current_token <> char, tokens)
          is_digit?(char) ->
            tokenize(rest, current_token <> char, tokens)
          true ->
            new_tokens = tokens ++ finalize_token(current_token)
            tokenize(rest, "", new_tokens)
        end
    end
  end

  defp is_letter?(char) do
    char =~ ~r/[a-zA-Z]/
  end

  defp is_digit?(token) do
    token =~ ~r/[0-9]/
  end

  defp finalize_token(""), do: [{:eof, "eof"}]
  defp finalize_token(token) do
    case token do
      "def" -> [{:method_def, token }]
      "do" -> [{:method_open, token }]
      "end" -> [{:method_close, token }]
      "return" -> [{:method_ret, token}]
      _ -> 
        if is_digit?(token) do
          [{:number, token}]
        else
          [{:identifier, token}]
        end
    end
  end
end



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
    tokenize(input |> String.trim |> String.graphemes, "", [])
  end

  defp tokenize([], "", []), do: finalize_token("")
  defp tokenize([], "", tokens), do: tokens
  defp tokenize([], current_token, tokens) do
    final_token = finalize_token(current_token)
    case final_token do
      [{:eof}] -> tokens ++ final_token
      _ -> tokens ++ final_token ++ finalize_token("")
    end
  end
  defp tokenize([char | rest], current_token, tokens) do
    case char do
      # Null bytes
      "\0" ->
        tokenize(rest, "", tokens ++ finalize_token(""))

      "\s" ->
        cond do
          has_opening_quote?(current_token) -> 
            tokenize(rest, current_token <> char, tokens)
          current_token != "" -> 
            new_tokens = tokens ++ finalize_token(current_token)
            tokenize(rest, "", new_tokens)
          true -> 
            tokenize(rest, current_token <> char, tokens) 
        end

      # Newline
      "\n" ->
        new_tokens = tokens ++ finalize_token(current_token)
        tokenize(rest, "", new_tokens)

      # Tab
      "\t" ->
        new_tokens = tokens ++ finalize_token(current_token)
        tokenize(rest, "", new_tokens)

      # Opening quote for a string
      "\"" when current_token == "" -> 
        tokenize(rest, current_token <> char, tokens)

      # Closing quote for a string
      "\"" when current_token != "" -> 
        tokenize(rest, current_token <> char, tokens)

      # Other characters
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

  defp has_opening_quote?(token) do
    String.first(token) == "\""
  end

  defp has_closing_quote?(token) do
    String.last(token) == "\""
  end

  defp is_string?(token) do
    has_opening_quote?(token) && has_closing_quote?(token)
  end

  defp finalize_token(""), do: [{:eof}]
  defp finalize_token(token) do
    case token do
      "def" -> [{:define, nil}]
      "do" -> [{:do, nil}]
      "end" -> [{:end, nil}]
      "return" -> [{:return, nil }]
      _ -> 
        cond do
          is_digit?(token) -> [{:integer, token}]
          is_string?(token)  -> [{:string, token}]
          true -> [{:identifier, token}]
        end
    end
  end
end



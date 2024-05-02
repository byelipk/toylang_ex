defmodule Toylang.Core.LexerTest do
  use ExUnit.Case
  alias Toylang.Core.Lexer

  test "it parses a method definition" do
    lines = [
      "def count do    \n",
      " return    10\n",
      "end\n",
      "\n",
      "def speak do\n",
      " return \"Hello, world!\"\n",
      "end\n",
      "\n",
      "\n",
      "\n",
      "\0",
    ]
    source = List.to_string(lines)
    tokens = Lexer.get_tokens(source)
    assert tokens == [
      {:define},
      {:identifier, "count"},
      {:do},
      {:return},
      {:integer, "10"},
      {:end},
      {:define},
      {:identifier, "speak"},
      {:do},
      {:return},
      {:string, "\"Hello, world!\""},
      {:end},
      {:eof}
    ]
  end

  test "parse empty string" do
    assert Lexer.get_tokens("") == [{:eof}]
  end

  test "parse number" do
    assert Lexer.get_tokens("12345") == [{:integer, "12345"}, {:eof}]
  end

  test "it handles null bytes" do
    assert Lexer.get_tokens("\0") == [{:eof}]
  end

  test "it handles whitespace" do
    assert Lexer.get_tokens(" ") == [{:eof}]
  end

  test "it handles strings" do
    assert Lexer.get_tokens("\"hello\"") == [{:string, "\"hello\""}, {:eof}]
  end
end

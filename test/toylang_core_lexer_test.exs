defmodule Toylang.Core.LexerTest do
  use ExUnit.Case
  alias Toylang.Core.Lexer

  @tag :pending
  test "it parses a method definition" do
    lines = [
      "def hello do\n",
      " return 10\n",
      "end\n",
      "\n",
      "def world do\n",
      " return \"Hello, world!\"\n",
      "end\n",
      "\n",
    ]
    source = List.to_string(lines)
    tokens = Lexer.get_tokens(source)
    assert tokens == [
      {:define, nil},
      {:identifier, "hello"},
      {:do, nil},
      {:return, nil},
      {:integer, "10"},
      {:end, nil},
      {:define, nil},
      {:identifier, "world"},
      {:do, nil},
      {:return, nil},
      {:string, "\"Hello, world!\""},
      {:end, nil},
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

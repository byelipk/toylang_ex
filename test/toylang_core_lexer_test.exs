defmodule Toylang.Core.LexerTest do
  use ExUnit.Case
  alias Toylang.Core.Lexer

  test "parse empty string" do
    assert Lexer.get_tokens("") == [{:eof, "eof"}]
  end

  test "parse hello world" do
    source = "def hello do\n return 10\nend"
    tokens = Lexer.get_tokens(source)
    assert tokens == [
      {:method_def, "def"},
      {:identifier, "hello"},
      {:method_open, "do"},
      {:method_ret, "return"},
      {:number, "10"},
      {:method_close, "end"},
      # {:eof, "eof"}
    ]
  end
end

defmodule ToylangTest do
  use ExUnit.Case
  doctest Toylang

  test "greets the world" do
    assert Toylang.hello() == :world
  end
end

defmodule LunarshTest do
  use ExUnit.Case
  doctest Lunarsh

  test "greets the world" do
    assert Lunarsh.hello() == :world
  end
end

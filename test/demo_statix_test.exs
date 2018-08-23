defmodule DemoStatixTest do
  use ExUnit.Case
  doctest DemoStatix

  test "greets the world" do
    assert DemoStatix.hello() == :world
  end
end

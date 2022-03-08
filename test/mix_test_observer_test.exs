defmodule MixTestObserverTest do
  use ExUnit.Case
  doctest MixTestObserver

  test "greets the world" do
    assert MixTestObserver.hello() == :world
  end
end

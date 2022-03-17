defmodule MixTestObserverTest do
  use ExUnit.Case
  doctest MixTestObserver

  test "hello from mix task" do
    ret = Mix.Task.run("test.observer")
    assert :hello = ret
  end
end

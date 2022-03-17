defmodule MixTestObserverTest do
  use ExUnit.Case
  doctest MixTestObserver

  test "run by mix task" do
    ret = Mix.Task.run("test.observer", ["a", "b"])
    assert {:ok, ["a", "b"]} = ret
  end
end

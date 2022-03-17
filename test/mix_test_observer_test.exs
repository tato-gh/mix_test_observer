defmodule MixTestObserverTest do
  use ExUnit.Case
  doctest MixTestObserver

  test "run as mix task" do
    # Process is no halt, so get :ng on purpose.
    ret = Mix.Task.run("test.observer")
    assert :ng = ret
  end
end

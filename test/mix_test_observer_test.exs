defmodule MixTestObserverTest do
  use ExUnit.Case
  doctest MixTestObserver

  test "run as mix task" do
    # Success case run with no halt, so get :ng on purpose.
    ret = Mix.Task.run("test.observer")
    assert :ng = ret
  end
end

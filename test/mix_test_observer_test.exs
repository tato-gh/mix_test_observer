defmodule MixTestObserverTest do
  use ExUnit.Case
  doctest MixTestObserver

  test "run by mix task" do
    file_input = "test/support/file_input_case_test.txt"
    file_output = "/tmp/file_output.txt"
    ret = Mix.Task.run("test.observer", [file_input, file_output])
    assert {:ok, ^file_input, ^file_output} = ret
  end
end

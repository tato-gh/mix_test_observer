defmodule MixTestObserver.DummyTest do
  use ExUnit.Case

  # NOTE: These tests are run through file input, like `test/support/file_input_case_test.txt`

  @moduletag :external

  test "case true" do
    assert true
  end

  test "case false" do
    assert false
  end
end

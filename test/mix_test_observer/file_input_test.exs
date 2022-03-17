defmodule MixTestObserver.FileInputTest do
  use ExUnit.Case
  doctest MixTestObserver.FileInput

  alias MixTestObserver.FileInput

  describe "parse/1" do
    test "return `:error` when invalid path" do
      assert {:error, _} = FileInput.parse("not_existing/path")
    end

    test "return `:error` when empty" do
      assert {:error, "nothing"} = FileInput.parse("test/support/file_input_empty.txt")
    end

    test "return `:test` when path is `test/` directory" do
      path = "test/support/file_input_case_test.txt"
      assert {:test, _} = FileInput.parse(path)
    end

    test "return `:run_anyway` when path is NOT `test/` directory" do
      path = "test/support/file_input_case_other.txt"
      assert {:run_anyway, _} = FileInput.parse(path)
    end
  end
end

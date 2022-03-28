defmodule MixTestObserver.FileInputTest do
  use ExUnit.Case
  doctest MixTestObserver.FileInput

  alias MixTestObserver.FileInput

  describe "parse/1" do
    test "return `:error` when invalid path" do
      assert {:error, _} = FileInput.parse("not_existing/path")
    end

    test "return `:error` when empty" do
      path = "test/support/file_input_empty.txt"
      assert {:error, "No entry."} = FileInput.parse(path)
    end

    test "return `:test` when path is started with `test/` directory" do
      path = "test/support/file_input_case_test.txt"
      assert {:test, _} = FileInput.parse(path)
    end

    test "return `:test` when path has `/test/` directory" do
      path = "test/support/.input_file.txt"

      content =
        File.read!("test/support/file_input_case_test.txt")
        |> Path.absname()

      File.write!(path, content)
      assert {:test, _} = FileInput.parse(path)
      File.rm(path)
    end

    test "return `:run_anyway` when path is NOT `test/` directory" do
      path = "test/support/file_input_case_other.txt"
      assert {:run_anyway, _} = FileInput.parse(path)
    end
  end
end

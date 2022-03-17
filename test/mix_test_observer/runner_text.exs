defmodule MixTestObserver.RunnerTest do
  use ExUnit.Case
  doctest MixTestObserver.Runner

  alias MixTestObserver.Runner

  describe "handle/1" do
    test "return `:error` when invalid path" do
      assert {:error, _} = Runner.handle("not_existing/path")
    end

    test "return :ok when valid path" do
      assert :ok = Runner.handle("test/support/file_input_case_test.txt")
      assert :ok = Runner.handle("test/support/file_input_case_other.txt")
    end
  end
end

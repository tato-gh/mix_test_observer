defmodule MixTestObserver.TesterTest do
  use ExUnit.Case
  doctest MixTestObserver.Tester

  alias MixTestObserver.Tester

  describe "start/2" do
    test "init" do
      {:ok, pid} = Tester.start("", "tmp/.result")
      assert "" = :sys.get_state(pid).test_args
      assert "tmp/.result" = :sys.get_state(pid).output_file_path
    end
  end
end

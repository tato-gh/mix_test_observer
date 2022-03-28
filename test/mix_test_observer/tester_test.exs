defmodule MixTestObserver.TesterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest MixTestObserver.Tester

  alias MixTestObserver.{Tester, FileObserver}

  @input_file "test/.input_file"

  describe "start/2" do
    test "init" do
      {:ok, pid} = Tester.start("", "tmp/.result")
      assert "" = :sys.get_state(pid).test_args
      assert "tmp/.result" = :sys.get_state(pid).output_file_path
    end
  end

  describe "handle_cast(:run)" do
    setup do
      File.write(@input_file, "")
      {:ok, _pid} = FileObserver.start(@input_file)

      on_exit(fn ->
        File.rm!(@input_file)
      end)
    end

    test "output test result to stdio" do
      output =
        capture_io(fn ->
          Tester.handle_cast({:run, "test/support/file_input_case_test.txt"}, %{
            test_args: [],
            output_file_path: nil
          })
        end)

      assert String.match?(output, ~r/0 failures/)
    end
  end
end

defmodule MixTestObserverTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest MixTestObserver

  alias MixTestObserver.{FileObserver, Tester}

  @input_file "test/.input_file"
  @output_file "test/.output_file"
  @test_args ["--include", "external:true"]

  test "run as mix task and show help" do
    # Process is no halt, so get help in this case.
    ret =
      capture_io(fn ->
        Mix.Task.run("test.observer")
      end)
    assert String.match?(ret, ~r/Usage/)
  end

  describe "integration with output" do
    setup do
      File.write(@input_file, "")
      File.write(@output_file, "")
      {:ok, _pid} = FileObserver.start(@input_file)
      {:ok, _pid} = Tester.start(@test_args, @output_file)
      # Wait for file_system handling, ...
      :timer.sleep(1000)

      on_exit(fn ->
        File.rm!(@input_file)
        File.rm!(@output_file)
      end)

      :ok
    end

    test "flow" do
      # Write test target to input_file
      file = File.open!(@input_file, [:write])
      IO.write(file, "test/support/dummy_test.exs:8")
      File.close(file)

      # Get test result
      output = wait_output(fn -> File.read!(@output_file) end)
      assert true = String.match?(output, ~r/0 failures/)
    end
  end

  defp wait_output(func, output \\ "", life_point \\ 10)

  defp wait_output(_func, "", 0), do: ""

  defp wait_output(func, "", life_point) do
    :timer.sleep(500)
    output = func.()
    wait_output(func, output, life_point - 1)
  end

  defp wait_output(_func, output, _life_point), do: output
end

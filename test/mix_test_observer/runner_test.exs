defmodule MixTestObserver.RunnerTest do
  use ExUnit.Case
  doctest MixTestObserver.Runner

  alias MixTestObserver.Runner

  @file_input "test/.mix_test_observer_file_input"
  @file_output "test/.mix_test_observer_file_output"
  @test_args ["--include", "external:true"]

  defp wait(func, output \\ "", life_point \\ 10)

  defp wait(_func, "", 0), do: ""

  defp wait(func, "", life_point) do
    :timer.sleep(500)
    output = func.()
    wait(func, output, life_point - 1)
  end

  defp wait(_func, output, _life_point), do: output

  describe "start/1" do
    test "observe file_input" do
      File.write(@file_input, "")
      File.write(@file_output, "")
      args = [@file_input, @file_output] ++ @test_args
      {:ok, pid} = Runner.start(args)

      # Wait for file_system handling, ...
      :timer.sleep(1000)

      # Trigger
      file = File.open!(@file_input, [:write])
      IO.write(file, "test/support/dummy_test.exs:8")
      File.close(file)

      # Get test result
      output = wait(fn -> File.read!(@file_output) end)

      # Cleaning
      :ok = GenServer.stop(pid)
      File.rm!(@file_input)
      File.rm!(@file_output)

      assert true = String.match?(output, ~r/0 failures/)
    end
  end
end

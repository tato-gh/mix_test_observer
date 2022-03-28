defmodule MixTestObserver do
  @moduledoc """
  Documentation for `MixTestObserver`.
  TODO same as README
  """

  alias MixTestObserver.{FileObserver, Tester}

  @doc """
  run observer
  TODO: args validation
  """
  def run(input_file_path, test_args, output_file_path \\ nil) do
    :ok = Application.ensure_started(:file_system)
    with \
         {:ok, _pid} <- FileObserver.start(input_file_path),
         {:ok, _pid} <- Tester.start(test_args, output_file_path)
    do
      no_halt_unless_in_repl()
    else
      _ -> show_help()
    end
  end

  def show_help do
    IO.puts """
    Invalid argument(or something went wrong).

    Usage: mix test.observer FILE1 [OPTIONS]
    Usage: mix test.observer FILE1 --output FILE2 [OPTIONS]

      FILE1: require existing path.
      FILE2: the file which test results are output.
      OPTIONS: same as `mix test` options. e.g. `--include external:true`
    """
  end

  defp no_halt_unless_in_repl do
    unless Code.ensure_loaded?(IEx) && IEx.started?() do
      :timer.sleep(:infinity)
    end
  end
end

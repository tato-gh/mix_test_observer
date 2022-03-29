defmodule MixTestObserver do
  @moduledoc """
  MixTestObserver is a semiauto test runner. Run `mix test` when each time you write whose target path to the observing file.
  """

  alias MixTestObserver.{FileObserver, Tester}

  @doc """
  Run observer.
  """
  def run(input_file_path, test_args, output_file_path \\ nil) do
    :ok = Application.ensure_started(:file_system)

    with {:ok, _pid} <- FileObserver.start(input_file_path),
         {:ok, _pid} <- Tester.start(test_args, output_file_path) do
      no_halt()
    else
      _ -> show_help()
    end
  end

  @doc """
  Show helps.
  """
  def show_help do
    IO.puts("""
    Invalid argument(or something went wrong).

    Usage: mix test.observer FILE1 [OPTIONS]
    Usage: mix test.observer FILE1 --output FILE2 [OPTIONS]

      FILE1: require existing path.
      FILE2: the file which test results are output.
      OPTIONS: same as `mix test` options. e.g. `--include external:true`
    """)
  end

  defp no_halt do
    :timer.sleep(:infinity)
  end
end

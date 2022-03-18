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
  def run([input_file_path, output_file_path | test_args]) do
    :ok = Application.ensure_started(:file_system)
    with \
         :ok <- FileObserver.start(input_file_path),
         :ok <- Tester.start(test_args, output_file_path)
    do
      no_halt_unless_in_repl()
    else
      _ -> show_help()
    end
  end

  def run(_) do
    show_help()
  end

  defp show_help do
    IO.puts """
    Invalid argument(or something went wrong).

    Usage: mix test.observer FILE1 FILE2 MIX_TEST_OPTIONS

      FILE1: require existing file path.
      FILE2: require file path.
      MIX_TEST_OPTIONS: same as `mix test` options. e.g. `--include external:true`
    """
  end

  defp no_halt_unless_in_repl do
    unless Code.ensure_loaded?(IEx) && IEx.started?() do
      :timer.sleep(:infinity)
    end
  end
end

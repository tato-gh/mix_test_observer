defmodule MixTestObserver do
  @moduledoc """
  MixTestObserver is a semiauto test runner. Run `mix test` when each time you write whose target path to the observing file.
  """

  alias MixTestObserver.{FileObserver, Tester}

  @doc """
  Run observer and wait infinity.
  """
  def run(input_file_path, test_args, output_file_path \\ nil) do
    :ok = Application.ensure_started(:file_system)

    with {:ok, _pid} <- FileObserver.start(input_file_path),
         {:ok, _pid} <- Tester.start(test_args, output_file_path) do
      IO.puts("Please write test target to `#{input_file_path}`, or ENTER to rerun.")
      wait(input_file_path, test_args, output_file_path)
      :ok
    else
      _ ->
        show_help()
        :ng
    end
  end

  @doc """
  Show helps.
  """
  @spec show_help() :: :ok
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

  defp wait(input_file_path, test_args, output_file_path) do
    IO.gets("")

    # if enter pressed
    MixTestObserver.Tester.run_test(input_file_path, test_args, output_file_path)
    wait(input_file_path, test_args, output_file_path)
  end
end

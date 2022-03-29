defmodule Mix.Tasks.Test.Observer do
  @moduledoc """
  Semiauto test runner. Run `mix test` when each time you write test target path to the observing file.

  ## Command line args

  Receives the filepath where content to be tested is written. This task observe the file and runs tests when there is a change in the file content.

  `mix test.observer <filepath>`

  ## Command line options

  - `--output` - Output file for the test result.
  - and receives `mix test` options.
  """

  use Mix.Task

  def run([input_file_path, "--output", output_file_path | test_args]) do
    MixTestObserver.run(input_file_path, test_args, output_file_path)
  end

  def run([input_file_path | test_args]) do
    MixTestObserver.run(input_file_path, test_args)
  end

  def run(_other) do
    MixTestObserver.show_help()
  end
end

defmodule Mix.Tasks.Test.Observer do
  use Mix.Task

  @moduledoc """
  TODO same as README
  """
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

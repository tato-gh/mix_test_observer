defmodule MixTestObserver do
  @moduledoc """
  Documentation for `MixTestObserver`.
  TODO same as README
  """

  alias MixTestObserver.Runner

  @doc """
  run observer
  """
  def run([file_input, file_output]) do
    Runner.handle(file_input)
    {:ok, file_input, file_output}
  end

  def run(_) do
    # TODO show usage
  end
end

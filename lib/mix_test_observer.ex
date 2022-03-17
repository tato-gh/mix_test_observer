defmodule MixTestObserver do
  @moduledoc """
  Documentation for `MixTestObserver`.
  TODO same as README
  """

  alias MixTestObserver.Runner

  @doc """
  run observer
  TODO: args validation
  """
  def run([_file_input, _file_output | _test_args] = args) do
    :ok = Application.ensure_started(:file_system)
    Runner.start(args)
    no_halt_unless_in_repl()
  end

  def run(_) do
    # TODO show usage
    :ng
  end

  defp no_halt_unless_in_repl do
    unless Code.ensure_loaded?(IEx) && IEx.started?() do
      :timer.sleep(:infinity)
    end
  end
end

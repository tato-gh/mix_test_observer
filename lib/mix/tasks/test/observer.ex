defmodule Mix.Tasks.Test.Observer do
  use Mix.Task

  @moduledoc """
  TODO same as README
  """

  defdelegate run(args), to: MixTestObserver
end

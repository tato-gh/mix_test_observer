defmodule MixTestObserver.Cli do
  def main(args) do
    Mix.Tasks.Test.Observer.run(args)
  end
end

defmodule MixTestObserver.Runner do
  @moduledoc """
  TODO
  """

  alias MixTestObserver.FileInput

  @doc """
  TODO
  """
  def start do
  end

  @doc """
  mock
  """
  def handle(path) do
    FileInput.parse(path)
    |> case do
      {:test, path} ->
        IO.puts "\nRun test: #{path}"
        run_cmd("mix test #{path}")
        |> write_file("/tmp/.output")
      {:run_anyway, _path} ->
        IO.puts "\nRun test --failed"
        result1 = run_cmd("mix test --failed")

        IO.puts "\nRun test --stale"
        result2 = run_cmd("mix test --stale")

        [result1, result2]
        |> Enum.join("\n\n")
        |> write_file("/tmp/.output")
      {:error, message} ->
        IO.puts "\nError: #{message}"
        {:error, message}
    end
  end

  defp run_cmd(cmd) do
    {output, _} = System.cmd("sh", ["-c", cmd], env: [{"MIX_ENV", "test"}])
    output
  end

  defp write_file(content, path) do
    File.write(path, content)
  end
end

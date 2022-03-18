defmodule MixTestObserver.Tester do
  @moduledoc """
  TODO
  """

  use GenServer

  alias MixTestObserver.{FileObserver, FileInput}

  @doc """
  TODO
  """
  def start(test_args, output_file_path) do
    GenServer.start_link(
      __MODULE__,
      %{
        test_args: test_args,
        output_file_path: output_file_path
      },
      name: __MODULE__
    )
    :ok
  end

  @doc """
  Interface to run.
  """
  def run(input_file_path) do
    GenServer.cast(__MODULE__, {:run, input_file_path})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @doc """
  TODO
  """
  @impl true
  def handle_cast({:run, input_file_path}, state) do
    test_args = state.test_args |> Enum.join(" ")

    FileInput.parse(input_file_path)
    |> case do
      {:test, path} ->
        run_cmd("mix test #{test_args} #{path}")
        |> write_file(state.output_file_path)
      {:run_anyway, _path} ->
        result1 = run_cmd("mix test --failed")
        result2 = run_cmd("mix test --stale")
        [result1, result2]
        |> Enum.join("\n\n\n\n")
        |> write_file(state.output_file_path)
      {:error, message} ->
        IO.puts "\n\n==== Error: #{message}"
        {:error, message}
    end

    FileObserver.unlock()

    {:noreply, state}
  end

  defp run_cmd(cmd) do
    IO.puts "\n\n==== RUN: #{cmd}"
    {output, _} = System.cmd("sh", ["-c", cmd], env: [{"MIX_ENV", "test"}])
    output
  end

  defp write_file(content, path) do
    IO.puts content

    file = File.open!(path, [:write])
    IO.write(file, content)
    File.close(file)
  end
end

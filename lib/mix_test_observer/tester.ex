defmodule MixTestObserver.Tester do
  @moduledoc """
  Tester is the process to run `mix test`.
  """

  use GenServer

  alias MixTestObserver.{FileObserver, FileInput}

  @doc """
  Public interface to start.
  """
  @spec start(test_args :: list, output_file_path :: String.t() | nil) :: {:ok, pid()}
  def start(test_args, output_file_path \\ nil) do
    GenServer.start_link(
      __MODULE__,
      %{
        test_args: test_args,
        output_file_path: output_file_path
      },
      name: __MODULE__
    )
  end

  @doc """
  Interface to run test.
  """
  @spec run(input_file_path :: String.t()) :: :ok
  def run(input_file_path) do
    GenServer.cast(__MODULE__, {:run, input_file_path})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @doc """
  - :run - Run the `mix test` and show (and write) results.
  """
  @impl true
  def handle_cast({:run, input_file_path}, state) do
    test_args = state.test_args |> Enum.join(" ")

    run_test(input_file_path, test_args, state.output_file_path)
    FileObserver.unlock()

    {:noreply, state}
  end

  def run_test(input_file_path, test_args, output_file_path) do
    FileInput.parse(input_file_path)
    |> case do
      {:test, path} ->
        run_cmd("test #{test_args} #{path}")
        |> report(output_file_path)

      {:run_anyway, _path} ->
        result1 = run_cmd("test --failed")
        result2 = run_cmd("test --stale")

        [result1, result2]
        |> Enum.join("\n\n\n\n")
        |> report(output_file_path)

      {:error, message} ->
        IO.puts("\n\n==== Error: #{message}")
        {:error, message}
    end
  end

  defp run_cmd(cmd) do
    IO.puts("\n\n==== RUN: #{cmd}")
    cmd = "mix do run -e 'Application.put_env(:elixir, :ansi_enabled, true)', #{cmd}"
    {output, _} = System.cmd("sh", ["-c", cmd], env: [{"MIX_ENV", "test"}])
    IO.puts(output)
    output
  end

  defp report(_content, nil), do: nil

  defp report(content, path) do
    file = File.open!(path, [:write, :utf8])
    IO.write(file, content)
    File.close(file)
  end
end

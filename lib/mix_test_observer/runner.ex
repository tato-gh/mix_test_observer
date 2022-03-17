defmodule MixTestObserver.Runner do
  @moduledoc """
  TODO
  """

  use GenServer

  alias MixTestObserver.FileInput

  @doc """
  TODO
  """
  def start([file_input, file_output | test_args]) do
    # TODO: check file file-path
    GenServer.start_link(
      __MODULE__,
      %{
        file_input: file_input,
        file_output: file_output,
        test_args: test_args
      },
      name: __MODULE__
    )
  end

  @impl true
  def init(cfg) do
    opts = [dirs: [cfg.file_input], name: :mix_test_observer]
    case FileSystem.start_link(opts) do
      {:ok, _} ->
        FileSystem.subscribe(:mix_test_observer)
        IO.puts "Start observation of `#{cfg.file_input}`."
        {:ok, cfg}
      other ->
        IO.puts "Could not start the file system monitor."
        other
    end
  end

  @doc """
  TODO
  """
  @impl true
  def handle_info({:file_event, _, {path, _events}}, state) do
    test_args = state.test_args |> Enum.join(" ")
    IO.inspect path

    FileInput.parse(path)
    |> case do
      {:test, path} ->
        IO.puts "\nRun test: #{path}"
        run_cmd("mix test #{path} #{test_args}")
        |> IO.puts()
        |> write_file(state.file_output)
      {:run_anyway, _path} ->
        IO.puts "\nRun test --failed"
        result1 = run_cmd("mix test --failed")
        IO.puts "\nRun test --stale"
        result2 = run_cmd("mix test --stale")
        [result1, result2]
        |> Enum.join("\n\n")
        |> IO.puts()
        |> write_file(state.file_output)
      {:error, message} ->
        IO.puts "\nError: #{message}"
        {:error, message}
    end

    {:noreply, state}
  end

  defp run_cmd(cmd) do
    {output, _} = System.cmd("sh", ["-c", cmd], env: [{"MIX_ENV", "test"}])
    output
  end

  defp write_file(content, path) do
    File.write(path, content)
  end
end

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
    start_file_system(cfg)
    |> case do
      {:ok, pid} ->
        IO.puts "Start observation of `#{cfg.file_input}`."
        {:ok, cfg |> Map.put(:file_system_pid, pid)}
      other ->
        IO.puts "Could not start the file system monitor."
        other
    end
  end

  @impl true
  def terminate(reason, state) do
    GenServer.stop(state.file_system_pid, reason)
  end

  def start_file_system(cfg) do
    opts = [dirs: [cfg.file_input]]
    case FileSystem.start_link(opts) do
      {:ok, pid} = ret ->
        FileSystem.subscribe(pid)
        ret
      other ->
        other
    end
  end

  def restart_file_system(cfg) do
    :ok = GenServer.stop(cfg.file_system_pid)
    start_file_system(cfg)
  end


  @doc """
  TODO
  """
  @impl true
  def handle_info({:file_event, _, {path, _events}}, state) do
    test_args = state.test_args |> Enum.join(" ")

    FileInput.parse(path)
    |> case do
      {:test, path} ->
        IO.puts "\n\n==== RUN: #{path}"
        run_cmd("mix test #{test_args} #{path}")
        |> write_file(state.file_output)
      {:run_anyway, _path} ->
        IO.puts "\n\n==== RUN: test --failed"
        result1 = run_cmd("mix test --failed")
        IO.puts "\n\n==== RUN: test --stale"
        result2 = run_cmd("mix test --stale")
        [result1, result2]
        |> Enum.join("\n\n\n\n")
        |> write_file(state.file_output)
      {:error, message} ->
        IO.puts "\n\n==== Error: #{message}"
        {:error, message}
    end

    restart_file_system(state)
    |> case do
      {:ok, pid} ->
        {:noreply, state |> Map.put(:file_system_pid, pid)}
      _other ->
        {:stop, "cannot observe", state |> Map.put(:file_system_pid, nil)}
    end
  end

  defp run_cmd(cmd) do
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

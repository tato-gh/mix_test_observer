defmodule MixTestObserver.FileObserver do
  @moduledoc """
  FileObserver is the process to observe file and call/cast event.
  """

  use GenServer

  alias MixTestObserver.Tester

  @doc """
  Public interface to start observation.
  """
  def start(path) do
    with true <- File.exists?(path) do
      GenServer.start_link(
        __MODULE__,
        %{
          path: path,
          lock: false,
          file_system_pid: nil
        },
        name: __MODULE__
      )
      |> case do
        {:ok, pid} ->
          IO.puts("Start observation of `#{path}`.")
          {:ok, pid}

        _ ->
          IO.puts("Could not start the file system monitor.")
          :ng
      end
    else
      _ -> :ng
    end
  end

  @doc """
  Public interface to unlock.
  """
  def unlock do
    GenServer.cast(__MODULE__, :unlock)
  end

  @impl true
  def init(state) do
    start_file_system(state.path)
    |> case do
      {:ok, pid} ->
        {:ok, state |> Map.put(:file_system_pid, pid)}

      other ->
        other
    end
  end

  @impl true
  def terminate(reason, state) do
    if state.file_system_pid do
      GenServer.stop(state.file_system_pid, reason)
    end
  end

  @doc """
  - :file_event - Run test through Tester. Observer must be locked immediately to prevent test repeatedly.
  """
  @impl true
  def handle_info({:file_event, _, {path, _events}}, state) do
    if not state.lock do
      Tester.run(path)
    end

    {
      :noreply,
      state |> Map.put(:lock, true)
    }
  end

  @doc """
  - :unlock - Unlock file_event handling and restart `file_system`, if not, `:file_event` occurs only onetime.
  """
  @impl true
  def handle_cast(:unlock, state) do
    {:ok, pid} = restart_file_system(state)

    {
      :noreply,
      state
      |> Map.put(:lock, false)
      |> Map.put(:file_system_pid, pid)
    }
  end

  defp start_file_system(path) do
    opts = [dirs: [path]]

    case FileSystem.start_link(opts) do
      {:ok, pid} = ret ->
        FileSystem.subscribe(pid)
        ret

      other ->
        other
    end
  end

  defp restart_file_system(state) do
    :ok = GenServer.stop(state.file_system_pid)
    start_file_system(state.path)
  end
end

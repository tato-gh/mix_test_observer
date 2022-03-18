defmodule MixTestObserver.FileObserver do
  @moduledoc """
  TODO
  """

  use GenServer

  alias MixTestObserver.Tester

  @doc """
  TODO
  """
  def start(path) do
    with \
         true <- File.exists?(path)
    do
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
        {:ok, _} ->
          IO.puts "Start observation of `#{path}`."
          :ok
        _ ->
          IO.puts "Could not start the file system monitor."
          :ng
      end
    else
      _ -> :ng
    end
  end

  @doc """
  Interface to unlock.
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
  Run test through Tester. Observer must be locked immediately to prevent test repeatedly.
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
  Unlock file_event.
  And restart `file_system`, if not `:file_event` occurs only onetime.
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

  @doc """
  TODO
  """
  def start_file_system(path) do
    opts = [dirs: [path]]
    case FileSystem.start_link(opts) do
      {:ok, pid} = ret ->
        FileSystem.subscribe(pid)
        ret
      other ->
        other
    end
  end

  @doc """
  TODO
  """
  def restart_file_system(state) do
    :ok = GenServer.stop(state.file_system_pid)
    start_file_system(state.path)
  end
end

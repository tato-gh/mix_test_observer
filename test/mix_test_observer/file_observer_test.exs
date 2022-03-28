defmodule MixTestObserver.FileObserverTest do
  use ExUnit.Case
  doctest MixTestObserver.FileObserver

  alias MixTestObserver.FileObserver

  @input_file "test/.input_file"

  describe "start/1" do
    setup :input_file_creation

    test "success" do
      assert {:ok, pid} = FileObserver.start(@input_file)
      assert is_pid(pid)
    end

    test "failure" do
      assert :ng = FileObserver.start("")
    end
  end

  describe "unlock/1" do
    setup :input_file_creation

    setup do
      {:ok, pid} = FileObserver.start(@input_file)
      :sys.replace_state(pid, & Map.put(&1, :lock, true))
      [pid: pid]
    end

    test "set unlock", context do
      :ok = FileObserver.unlock()
      assert false == :sys.get_state(context.pid).lock
    end

    test "restart file_system", context do
      prev_pid = :sys.get_state(context.pid).file_system_pid
      :ok = FileObserver.unlock()
      assert prev_pid != :sys.get_state(context.pid).file_system_pid
    end
  end

  defp input_file_creation(_context) do
    File.touch!(@input_file)

    on_exit(fn ->
      File.rm!(@input_file)
    end)
  end
end

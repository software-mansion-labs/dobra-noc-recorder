defmodule DobraNoc.PipelineTest do
  use ExUnit.Case

  alias DobraNoc.Pipeline

  test "store 5s recording" do
    File.mkdir_p!("out")
    File.rm("out/out.flac")
    {:ok, pid} = Pipeline.start_link()
    Pipeline.play(pid)
    Process.sleep(8000)

    filename = "out/cut_#{Membrane.Time.vm_time() |> Membrane.Time.to_iso8601()}"

    now = :os.system_time(:seconds)

    send(pid, {:save_rec, %{from: now - 6, to: now - 1, location: filename}})

    Process.sleep(3000)

    File.cp!(filename <> ".flac", "out/out.flac")
  end
end

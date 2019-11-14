defmodule DobraNoc.PipelineTest do
  use ExUnit.Case

  alias DobraNoc.Pipeline
  alias Membrane.Time

  test "store 5s recording" do
    File.rm("out/out.flac")
    {:ok, pid} = Pipeline.start_link()
    Pipeline.play(pid)
    Process.sleep(8000)

    filename = "out/cut_#{Time.vm_time() |> Time.to_iso8601()}.flac"

    send(
      pid,
      {:cut, {Time.os_time() - Time.second(6), Time.os_time() - Time.second(1), filename}}
    )

    Process.sleep(3000)

    File.cp!(filename, "out/out.flac")
  end
end

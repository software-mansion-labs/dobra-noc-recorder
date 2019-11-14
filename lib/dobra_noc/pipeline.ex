defmodule DobraNoc.Pipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(_opts) do
    children = [
      mic: Membrane.Element.PortAudio.Source,
      encoder: Membrane.Element.FLAC.Encoder,
      parser: Membrane.Element.FLACParser,
      buffer: DobraNoc.RecordingBuffer
    ]

    links = [
      link(:mic) |> to(:encoder) |> to(:parser) |> to(:buffer)
    ]

    {{:ok, spec: %ParentSpec{children: children, links: links}}, %{}}
  end

  @impl true
  def handle_other({:cut, _args} = msg, state) do
    {{:ok, forward: {:buffer, msg}}, state}
  end
end

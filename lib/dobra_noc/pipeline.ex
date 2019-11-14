defmodule DobraNoc.Pipeline do
  use Membrane.Pipeline

  alias Membrane.Time

  def start_play(args) do
    with {:ok, pid} <- start_link(nil, args) do
      play(pid)
      {:ok, pid}
    end
  end

  @impl true
  def handle_init(_opts) do
    children = [
      mic: Membrane.Element.PortAudio.Source,
      encoder: Membrane.Element.FLAC.Encoder,
      parser: Membrane.Element.FLACParser,
      buffer: DobraNoc.RecordingBuffer
    ]

    links = %{
      {:mic, :output} => {:encoder, :input},
      {:encoder, :output} => {:parser, :input},
      {:parser, :output} => {:buffer, :input}
    }

    {{:ok, spec: %Pipeline.Spec{children: children, links: links}}, %{}}
  end

  @impl true
  def handle_other({:save_rec, %{from: from, to: to, location: location}}, state) do
    msg =
      {:save_rec, %{from: Time.seconds(from), to: Time.seconds(to), location: "#{location}.flac"}}

    {{:ok, forward: {:buffer, msg}}, state}
  end
end

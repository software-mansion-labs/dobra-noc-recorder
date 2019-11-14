defmodule DobraNoc.RecordingBuffer do
  use Membrane.Sink
  use Membrane.Log, tags: :dobranoc_recording_buffer

  alias Membrane.{Buffer, Time}
  alias Membrane.Caps.Audio.FLAC
  alias Membrane.Caps.Audio.FLAC.FrameMetadata

  def_options length: [
                type: :time,
                default: 15 |> Time.minutes()
              ]

  def_input_pad :input, caps: FLAC, demand_unit: :buffers

  @impl true
  def handle_init(options) do
    {:ok, Map.from_struct(options) |> Map.merge(%{q: Qex.new(), headers: []})}
  end

  @impl true
  def handle_prepared_to_playing(_ctx, state) do
    {{:ok, demand: :input}, state}
  end

  @impl true
  def handle_write(:input, %Buffer{payload: payload, metadata: %FrameMetadata{}}, _ctx, state) do
    %{q: q, length: length} = state
    time = Time.os_time()
    q = Qex.push(q, {time, payload})
    {oldest_time, _frame} = Qex.first!(q)

    q =
      if time - oldest_time > length do
        {_, q} = Qex.pop(q)
        q
      else
        q
      end

    {{:ok, demand: :input}, %{state | q: q}}
  end

  @impl true
  def handle_write(:input, %Buffer{payload: header}, _ctx, state) do
    {{:ok, demand: :input}, state |> Map.update!(:headers, &(&1 ++ [header]))}
  end

  @impl true
  def handle_other({:save_rec, args}, _ctx, state) do
    frames =
      state.q
      |> Enum.drop_while(fn {time, _frame} -> time < args.from end)
      |> Enum.take_while(fn {time, _frame} -> time <= args.to end)
      |> Enum.map(fn {_time, frame} -> frame end)

    :ok = File.write(args.location, state.headers ++ frames, [:binary, :write])
    {:ok, state}
  end
end

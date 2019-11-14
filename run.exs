{:ok, _pid} = DobraNoc.Pipeline.start_link(nil, name: :pip)
DobraNoc.Pipeline.play(:pip)

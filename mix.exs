defmodule DobraNoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :dobra_noc,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      aliases: [start: "run --no-halt"],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {DobraNoc, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.6"},
      {:jason, "~> 1.1"},
      {:membrane_core, "~> 0.4.2"},
      {:membrane_caps_audio_raw, "0.1.8"},
      {:membrane_element_portaudio, "~> 0.2.5"},
      {:membrane_caps_audio_flac, "~> 0.1.1"},
      {:membrane_element_flac_encoder,
       github: "membraneframework/membrane-element-flac-encoder", branch: "develop"},
      {:membrane_element_flac_parser, "~> 0.2"},
      {:membrane_loggers, "~> 0.2.0"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:qex, "~> 0.5.0"}
    ]
  end
end

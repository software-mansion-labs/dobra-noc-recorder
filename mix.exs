defmodule DobraNoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :dobra_noc,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:membrane_core, path: "../membrane/membrane-core", override: true},
      {:membrane_caps_audio_mpeg, "~> 0.2.0"},
      {:membrane_caps_audio_raw, "0.1.8"},
      {:membrane_element_portaudio, "~> 0.2.5"},
      {:membrane_element_ffmpeg_swresample, "~> 0.2.5"},
      {:membrane_element_lame, "~> 0.3.6"},
      {:membrane_element_file, "~> 0.2.4"},
      {:membrane_element_mpegaudioparse, "~> 0.2"},
      {:membrane_element_flac_encoder, path: "../membrane/membrane-element-flac-encoder"},
      {:membrane_element_flac_parser, "~> 0.2"},
      {:membrane_loggers, "~> 0.2.0"},
      {:qex, "~> 0.5.0"}
    ]
  end
end

# Dobra Noc recorder

Recorder for the [Dobra Noc](https://github.com/ciembor/dobra-noc) project.

## Installation

Firstly, make sure you have [Elixir installed](https://elixir-lang.org/install.html) and that the following native dependencies are available in your system:

- Portaudio 19.6.0
- FLAC 1.3.2

If not, install them with

```bash
apt-get update
apt-get -y install portaudio19-dev
apt-get -y install libflac-dev
```

Then fetch elixir dependencies
```bash
mix deps.get
```

## Running

Once installed, project can be run by typing `mix start`. The following system variables are supported:

- `DOBRANOC_IP` - by default `127.0.0.1`
- `DOBRANOC_PORT` - by default `8123`

## API

To save recording from given period, make a POST request to `/save_rec`, with a JSON containing the following fields:
- from - unix timestamp (integer), beginning of recording
- to - unix timestamp (integer), end of recording
- location - path where to save recording (string); ".flac" extension will be appended

Example:

```bash
curl -H "Content-Type: application/json" \
  -d '{"from":'$(($(date +%s) - 10))', "to":'$(($(date +%s) - 5))', "location":"out/out"}' \
  -X POST http://localhost:8123/save_rec
```

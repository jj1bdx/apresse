# apresse: APRS software for Erlang and Elixir

For [Kenji Rikitake's presentation at Code BEAM STO 2018](https://codesync.global/conferences/code-beam-sto-2018/#Schedule)

## Goals

* APRS-IS connection middleware/API for Erlang/Elixir

## Sub-goals

* 1: communicating with APRS-IS server
* 2: APRS-IS message parsing/forming
* 3: displaying information from APRS-IS to Web browsers

## Non-goals

* AX.25 raw messages will *not* be handled directly in this project
* No NIFs - stick to native Erlang/Elixir
* Platform agnostic (primarily targeted for macOS/FreeBSD (will be running on Linux too))

## License

MIT. See [LICENSE](LICENSE)

## Why calling *apresse*?

### Requirements of naming

* The name should contain something similar to APRS
* The name should contains something similar to `erl` or `ex`, popular prefixes/suffixes for Erlang/Elixir software
* The name *must not be offensive*
* The origin of the word should be easily imaginable

### Other miscellaneous trivia

* This software has to be written in hurry; as in Portuguese word *apressar*
* The pronunciation sounds familiar: it's La Presse in Quebec without the L
* The name sounds like *press*, reminding the publication purpose

[End of README]

# melihcolpan/tap

Homebrew formulae for [reqstorm](https://reqstorm.github.io), a tool for sending thousands of HTTP requests with rate limits, retries, progress and logging.

## Install

```console
$ brew install melihcolpan/tap/reqstorm
```

or

```console
$ brew tap melihcolpan/tap
$ brew install reqstorm
```

Works on macOS and Linux. The formula installs reqstorm with SOCKS proxy support in its own Python environment, so it does not touch your other Python packages.

```console
$ reqstorm urls.txt -o results.jsonl --rate 100/min --retries 2
$ reqstorm --help
```

## Update

```console
$ brew upgrade reqstorm
```

New reqstorm releases on PyPI are picked up automatically within a day.

## Without Homebrew

```console
$ pipx install "reqstorm[socks]"     # or: uv tool install "reqstorm[socks]"
$ python -m pip install reqstorm      # as a library
```

Documentation: [reqstorm.github.io](https://reqstorm.github.io) · Source: [github.com/melihcolpan/reqstorm](https://github.com/melihcolpan/reqstorm)

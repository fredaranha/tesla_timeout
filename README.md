<h1 align="center">Tesla Timeout</h1>

<p align="center">
  <img alt="Tesla Timeout" src="https://github.com/globocom/tesla_timeout/blob/master/assets/tesla_timeout.png?raw=true" width="256">
</p>

<p align="center">
  A Timeout Middleware for Tesla Elixir HTTP Client
</p>

<p align="center">
  <a href="https://travis-ci.org/globocom/tesla_timeout">
    <img alt="Travis" src="https://travis-ci.org/globocom/tesla_timeout.svg">
  </a>
  <a href="https://hex.pm/packages/tesla_timeout">
    <img alt="Hex" src="https://img.shields.io/hexpm/dt/tesla_timeout.svg">
  </a>
</p>

## About
The timeout configuration may vary depending of the Tesla adapter being used (as well as its effects). To have an assertive and unified way of controlling timeout, we created this middleware that encapsulates the request on a GenServer with timeout. With this implementation we make sure that the timeout is always respected independent of the troubles the client may have.

## Installation

```elixir
def deps do
  [
    {:tesla_timeout, "~> 0.1.0"}
  ]
end
```

## Usage:

```elixir
defmodule GoogleClient do
  use Tesla
  plug Tesla.Middleware.Timeout, :timer.seconds(2)
end

try do
  GoogleClient.get("http://www.google.com:81/")
rescue e in Tesla.Error ->
  IO.inspect(e)
end
#  %Tesla.Error{
#    message: "Elixir.Tesla.Middleware.Timeout: Request timeout.",
#    reason: :timeout
#  }
```

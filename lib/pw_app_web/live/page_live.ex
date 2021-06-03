defmodule PwAppWeb.PageLive do
  use PwAppWeb, :live_view

  alias Password.Options
  alias Password.Constant

  @separator_types Constant.separator_types()

  @impl true
  def mount(_params, _session, socket) do
    password = %Password{}

    socket =
      socket
      |> assign(:type, password.type)
      |> assign(:options, password.options)
      |> assign(:output, password.output)
      |> assign(:analysis, password.analysis)
      |> assign(:separator_types, @separator_types)

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "generate",
        %{
          "options" => %{
            "word_count" => word_count,
            "pin_length" => pin_length,
            "character_count" => character_count,
            "uppercase" => uppercase,
            "separator_type" => separator_type,
            "symbols" => symbols,
            "numbers" => numbers
          },
          "type" => type
        },
        socket
      ) do
    results =
      Password.generate(%Password{
        type: type,
        options: %Options{
          word_count: String.to_integer(word_count),
          pin_length: String.to_integer(pin_length),
          character_count: String.to_integer(character_count),
          uppercase: String.to_atom(uppercase),
          separator_type: String.to_atom(separator_type),
          symbols: String.to_atom(symbols),
          numbers: String.to_atom(numbers)
        }
      })

    {:noreply,
     assign(socket,
       type: results.type,
       options: results.options,
       output: results.output,
       analysis: results.analysis
     )}
  end
end

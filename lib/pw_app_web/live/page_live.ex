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
      |> assign(:output_class, "")
      |> assign(:advice, [])

    {:ok, socket}
  end

  def output_class(output) do
    cond do
      output < 50 ->
        "text-4xl"

      output >= 50 and output < 100 ->
        "text-2xl"

      output >= 100 and output < 150 ->
        "text-xl"

      true ->
        "text-lg"
    end
  end

  def advice(results, type \\ "") do
    pin = type == "pin"
    memorable = type == "memorable"
    minimum_requirements = elem(results[:minimum_requirements], 1) > 0 and !pin

    Enum.map(results, fn {key, tuple} ->
      points = elem(tuple, 1)

      cond do
        !pin and key == :minimum_requirements and points == 0 ->
          "Make sure the password meets generic minimum requirements: at least 1 number, 1 symbol, a mix of uppercase and lowercase characters, and at least 8 characters long."

        key == :length and points < 64 ->
          "Try making it longer."

        !pin and key == :uppercase and minimum_requirements and points < 15 ->
          "Try adding more uppercase letters."

        !pin and key == :lowercase and minimum_requirements and points < 15 ->
          "Try adding more lowercase letters."

        !pin and key == :numbers and points == 0 ->
          "Try adding numbers."

        !pin and key == :symbols and points == 0 ->
          "Try adding symbols (special characters)."

        !memorable and key == :repeat_characters and points < -1 ->
          "Try repeating fewer characters."

        !memorable and !pin and key == :consecutive_lowercase and points < 0 ->
          "Try breaking up sets of lowercase letters with uppercase letters, numbers, or symbols."

        !memorable and !pin and key == :consecutive_uppercase and points < 0 ->
          "Try breaking up sets of uppercase letters with lowercase letters, numbers, or symbols."

        !pin and key == :consecutive_numbers and points < 0 ->
          "Try breaking up sets of numbers with letters or symbols."

        key == :sequential_numbers and points < 0 ->
          "Avoid using sequential numbers (eg '1234')"

        !pin and key == :sequential_alpha and points < 0 ->
          "Avoid using sequential letters from the alphabet (eg 'abc' or 'zyx')."

        !pin and key == :sequential_symbols and points < 0 ->
          "Avoid using sequential symbols as they are laid out on the keyboard (eg !@#)."

        key == :contains_year and points < 0 ->
          "Avoid including years."

        true ->
          nil
      end
    end)
    |> Enum.filter(fn x -> x != nil end)
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
       analysis: results.analysis,
       output_class: output_class(String.length(results.output)),
       advice: advice(results.analysis.results, results.type)
     )}
  end

  def handle_event("refresh", _value, socket) do
    results =
      Password.generate(%Password{
        type: socket.assigns.type,
        options: %Options{
          word_count: socket.assigns.options.word_count,
          pin_length: socket.assigns.options.pin_length,
          character_count: socket.assigns.options.character_count,
          uppercase: socket.assigns.options.uppercase,
          separator_type: socket.assigns.options.separator_type,
          symbols: socket.assigns.options.symbols,
          numbers: socket.assigns.options.numbers
        }
      })

    {:noreply,
     assign(socket, %{
       type: results.type,
       options: results.options,
       output: results.output,
       analysis: results.analysis,
       output_class: output_class(String.length(results.output)),
       advice: advice(results.analysis.results, results.type)
     })}
  end
end

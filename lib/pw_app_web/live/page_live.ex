defmodule PwAppWeb.PageLive do
  @moduledoc """
    To do!
  """

  use PwAppWeb, :live_view

  alias Password.Options
  alias Password.Constant
  alias Password.Feedback
  alias Password.Ui

  @separator_types Constant.separator_types()

  @impl true
  def mount(_params, _session, socket) do
    password = %Password{}

    socket =
      socket
      |> assign(:show_section, %{
        strength: false,
        refresh: false,
        next: false,
        analysis: false
      })
      |> assign(:type, password.type)
      |> assign(:options, password.options)
      |> assign(:input, "")
      |> assign(:output, password.output)
      |> assign(:analysis, password.analysis)
      |> assign(:separator_types, @separator_types)
      |> assign(:output_font_size, "")
      |> assign(:strength_meter_color, "bg-white")
      |> assign(:attack_meter_color, "bg-white")
      |> assign(:attack_time, [])
      |> assign(:advice, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("generate", %{"type" => type}, socket) when type == "custom" do
    {:noreply,
     assign(socket,
       type: type,
       output: socket.assigns.output,
       show_section: %{strength: false, refresh: false, next: true, analysis: true}
     )}
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
       input: results.input,
       output: results.output,
       analysis: results.analysis,
       output_font_size: Ui.output_font_size(String.length(results.output)),
       strength_meter_color: Ui.strength_meter_color(results.analysis.strength),
       attack_meter_color: Ui.attack_meter_color(results.analysis.zxcvbn.score),
       attack_time: Feedback.attack_time(results.analysis.zxcvbn.crack_times_display),
       advice: Feedback.advice(results.analysis, results.type),
       show_section: %{
         strength: Enum.member?(["memorable", "pin", "random"], type),
         refresh: Enum.member?(["memorable", "pin", "random"], type),
         next: true,
         analysis: true
       }
     )}
  end

  def handle_event("generate", _value, socket) do
    {:noreply, socket}
  end

  def handle_event("custom_entry", %{"value" => value}, socket) do
    {:noreply, assign(socket, %{input: value})}
  end

  def handle_event("analyze", _value, socket) when socket.assigns.input != "" do
    results =
      Password.generate(%Password{
        type: socket.assigns.type,
        input: socket.assigns.input
      })

    {:noreply,
     assign(socket, %{
       type: results.type,
       options: results.options,
       output: results.output,
       input: results.input,
       analysis: results.analysis,
       advice: Feedback.advice(results.analysis, results.type),
       output_font_size: Ui.output_font_size(String.length(results.output)),
       strength_meter_color: Ui.strength_meter_color(results.analysis.strength),
       attack_meter_color: Ui.attack_meter_color(results.analysis.zxcvbn.score),
       attack_time: Feedback.attack_time(results.analysis.zxcvbn.crack_times_display),
       show_section: %{strength: false, refresh: false, next: true, analysis: true}
     })}
  end

  def handle_event("analyze", _value, socket) do
    {:noreply, socket}
  end

  def handle_event("refresh", _value, socket) do
    results =
      Password.generate(%Password{
        type: socket.assigns.type,
        options: socket.assigns.options
      })

    {:noreply,
     assign(socket, %{
       type: results.type,
       options: results.options,
       output: results.output,
       analysis: results.analysis,
       advice: Feedback.advice(results.analysis, results.type),
       output_font_size: Ui.output_font_size(String.length(results.output)),
       strength_meter_color: Ui.strength_meter_color(results.analysis.strength),
       attack_meter_color: Ui.attack_meter_color(results.analysis.zxcvbn.score),
       attack_time: Feedback.attack_time(results.analysis.zxcvbn.crack_times_display)
     })}
  end
end

defmodule PwAppWeb.Ui do
  @moduledoc """
    To do!
  """
  @spec output_font_size(integer()) :: String.t()
  def output_font_size(output) do
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

  @spec strength_meter_color(integer()) :: integer
  def strength_meter_color(strength) do
    cond do
      strength < 25 -> 25
      strength >= 25 and strength < 50 -> 50
      strength >= 50 and strength < 75 -> 75
      strength >= 75 -> 100
      true -> 0
    end
  end

  @spec attack_meter_color(integer()) :: integer
  def attack_meter_color(score) do
    cond do
      score == 1 -> 25
      score == 2 -> 50
      score == 3 -> 75
      score == 4 -> 100
      true -> 0
    end
  end

  def tailwind_colors do
    # IT GOT PRUNED ON PROD :<
    # To-do: Fix this and make it better.
    ["bg-meter-0", "bg-meter-25", "bg-meter-50", "bg-meter-75", "bg-meter-100"]
  end
end

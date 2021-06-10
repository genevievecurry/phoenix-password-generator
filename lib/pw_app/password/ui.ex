defmodule Password.Ui do
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

  @spec strength_meter_color(integer()) :: String.t()
  def strength_meter_color(strength) do
    cond do
      strength < 25 -> "bg-meter-25"
      strength >= 25 and strength < 50 -> "bg-meter-50"
      strength >= 50 and strength < 75 -> "bg-meter-75"
      strength >= 75 -> "bg-meter-100"
      true -> "bg-white"
    end
  end

  @spec crackable_meter_color(integer()) :: String.t()
  def crackable_meter_color(score) do
    cond do
      score == 1 -> "bg-meter-25"
      score == 2 -> "bg-meter-50"
      score == 3 -> "bg-meter-75"
      score == 4 -> "bg-meter-100"
      true -> "bg-white"
    end
  end
end

defmodule Password.Feedback do
  def advice(analysis, type \\ "")

  def advice(analysis, type) when analysis.analyzed do
    results = analysis.results
    zxcvbn = analysis.zxcvbn
    pin = type == "pin"
    memorable = type == "memorable"

    suggestions = Enum.map(zxcvbn.feedback.suggestions, fn suggestion -> suggestion end)

    Enum.map(results, fn {key, tuple} ->
      points = elem(tuple, 1)

      cond do
        !pin and key == :minimum_requirements and points == 0 ->
          "Make sure the password meets generic minimum requirements: at least 1 number, 1 symbol, a mix of uppercase and lowercase characters, and at least 8 characters long."

        key == :length and points < 64 ->
          "Try making it longer."

        !pin and key == :uppercase and points < 15 ->
          "Try adding more uppercase letters."

        !pin and key == :lowercase and points < 15 ->
          "Try adding more lowercase letters."

        !pin and key == :numbers and points < 15 ->
          "Try adding more numbers."

        !pin and key == :symbols and points < 15 ->
          "Try adding more symbols (special characters)."

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
    |> Enum.concat(suggestions)
    |> Enum.filter(fn item -> item != nil end)
  end

  def advice(analysis, _type) when analysis.analyzed == false, do: []
  def advice, do: []

  @spec crackable_time(map()) :: list
  def crackable_time(crack_times_display) do
    Enum.map(crack_times_display, fn {key, value} ->
      color =
        cond do
          String.contains?(value, ["seconds", "second", "minute", "minutes", "hour"]) ->
            "bg-meter-25"

          String.contains?(value, ["hours", "day"]) ->
            "bg-meter-50"

          String.contains?(value, ["days", "week", "month", "months"]) ->
            "bg-meter-75"

          String.contains?(value, ["year", "years", "century", "centuries"]) ->
            "bg-meter-100"

          true ->
            "bg-purple-light"
        end

      label =
        case key do
          :offline_fast_hashing_1e10_per_second -> "Offline attack, fast hash, many cores."
          :offline_slow_hashing_1e4_per_second -> "Offline attack, slow hash, many cores."
          :online_no_throttling_10_per_second -> "Unthrottled online attack."
          :online_throttling_100_per_hour -> "Throttled online attack."
          _ -> "meh"
        end

      rate =
        case key do
          :offline_fast_hashing_1e10_per_second -> "10B/second"
          :offline_slow_hashing_1e4_per_second -> "10k/second"
          :online_no_throttling_10_per_second -> "10/second"
          :online_throttling_100_per_hour -> "100/hour"
          _ -> "meh"
        end

      %{
        color: color,
        label: label,
        rate: rate,
        time: value
      }
    end)
  end
end

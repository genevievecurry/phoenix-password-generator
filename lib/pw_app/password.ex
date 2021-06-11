defmodule Password do
  @moduledoc """
  A basic password generation module that can create three types of passwords: Random, Memorable, and PIN.

  - Random passwords are hard to crack and hard to remember.
  - Memorable passwords should also be difficult to crack, but are easier to remember as they use full words from the English dictionary
  - PINs are simply a set of numbers


  ## Examples
      iex> Password.start()


  """
  alias Password.Generator
  alias Password.Options
  alias Password.Analyzer

  require ZXCVBN

  defstruct type: "",
            options: %Options{},
            output: "",
            input: "",
            analysis: %{
              analyzed: false,
              score: 0,
              strength: 0,
              results: %{},
              zxcvbn: %{
                calc_time: 0,
                crack_times_display: %{
                  offline_fast_hashing_1e10_per_second: "",
                  offline_slow_hashing_1e4_per_second: "",
                  online_no_throttling_10_per_second: "",
                  online_throttling_100_per_hour: ""
                },
                crack_times_seconds: %{
                  offline_fast_hashing_1e10_per_second: 0.0,
                  offline_slow_hashing_1e4_per_second: 0.0,
                  online_no_throttling_10_per_second: 0.0,
                  online_throttling_100_per_hour: 0.0
                },
                feedback: %{
                  suggestions: [],
                  warning: ""
                },
                guesses: 0,
                guesses_log10: 0.0,
                password: "",
                score: 0,
                sequence: []
              }
            }

  def random(options \\ %Options{}), do: Generator.random(options)

  @spec memorable(
          atom
          | %{
              :numbers => false,
              :separator_type => atom,
              :symbols => false,
              :uppercase => boolean,
              :word_count => non_neg_integer,
              optional(any) => any
            }
        ) :: binary
  def memorable(options \\ %Options{}), do: Generator.memorable(options)
  def pin(options \\ %Options{}), do: Generator.pin(options)

  def generate(password \\ %Password{}) do
    output =
      case password.type do
        "memorable" -> Generator.memorable(password.options)
        "random" -> Generator.random(password.options)
        "pin" -> Generator.pin(password.options)
        "custom" -> password.input
        _ -> %{}
      end

    %Password{
      type: password.type,
      options: password.options,
      output: output,
      input: password.input,
      analysis: analyze(output)
    }
  end

  @spec analyze(String.t()) :: map()
  def(analyze(password)) do
    score = Analyzer.score(password)

    %{
      analyzed: true,
      score: score,
      strength: Analyzer.strength(score),
      results: Analyzer.results(password),
      zxcvbn: ZXCVBN.zxcvbn(password)
    }
  end
end

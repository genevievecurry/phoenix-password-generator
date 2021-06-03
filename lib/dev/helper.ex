defmodule Helper do
  # pid = Helper.live_list() |> hd()
  # :sys.get_state(pid)

  def live_list do
    Process.list()
    |> Enum.map(
      &{
        &1,
        Process.info(&1, [:dictionary])
        |> hd()
        |> elem(1)
        |> Keyword.get(:"$initial_call", {})
      }
    )
    |> Enum.filter(fn {_, process} ->
      process != nil && process != {} &&
        elem(process, 0) == Phoenix.LiveView.Channel
    end)
    |> Enum.map(&elem(&1, 0))
  end

  def state(pid) when is_pid(pid), do: :sys.get_state(pid)
end

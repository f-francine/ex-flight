defmodule ExFlight.Agents.UserAgent do
  @moduledoc """
  Saves the state of an user.
  """
  use Agent

  alias ExFlight.Types.User

  def start_link(_), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  def insert(%User{} = user) do
    Agent.update(__MODULE__, &do_insert(&1, user))
    {:ok, user.id}
  end

  defp do_insert(state, %User{id: id} = user), do: Map.put(state, id, user)

  def get(id), do: Agent.get(__MODULE__, &do_get(&1, id))

  defp do_get(state, id) do
    state
    |> Map.get(id)
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end

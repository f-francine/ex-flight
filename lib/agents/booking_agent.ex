defmodule ExFlight.Agents.BookingAgent do
  @moduledoc """
  Saves the state of a fligh booking.
  """
  use Agent

  alias ExFlight.Types.Booking

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def insert(%Booking{} = booking) do
    Agent.update(__MODULE__, &do_insert(&1, booking))
    {:ok, booking.id}
  end

  defp do_insert(state, %Booking{id: id} = booking), do: Map.put(state, id, booking)

  def get(booking_id), do: Agent.get(__MODULE__, &do_get(&1, booking_id))

  defp do_get(state, booking_id) do
    state
    |> Map.get(booking_id)
    |> case do
      nil -> {:error, :not_found}
      booking -> {:ok, booking}
    end
  end
end

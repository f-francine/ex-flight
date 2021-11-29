defmodule ExFlight.Booking do
  @moduledoc """
  Validates the booking input and when it is valid, inserts it.
  """

  require Logger

  alias ExFlight.Types.Booking
  alias ExFlight.Agents.BookingAgent

  @spec create(
          complete_date :: NaiveDateTime.t(),
          local_origin :: String.t(),
          local_destination :: String.t(),
          user_id :: String.t()
        ) ::
          {:ok, map()} | {:error, :invalid_email | :invalid_cpf}
  def create(%NaiveDateTime{} = complete_date, local_origin, local_destination, user_id) do
    with {:ok, booking} <- Booking.build(complete_date, local_origin, local_destination, user_id),
         {:ok, booking_id} <- BookingAgent.insert(booking) do
      Logger.info("Booking #{booking_id} successfully created.")
      {:ok, booking}
    end
  end

  @spec get(id :: String.t()) :: {:ok, map()} | {:error, :not_found}
  def get(id) do
    Logger.info("Getting booking #{id}.")

    case BookingAgent.get(id) do
      {:ok, _booking} = result ->
        result

      {:error, :not_found} = error ->
        Logger.error("Failed due to booking id not found.")
        error
    end
  end
end

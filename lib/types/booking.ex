defmodule ExFlight.Types.Booking do
  @moduledoc """
  Defines the booking struct.
  """

  @enforce_keys [:complete_date, :local_origin, :local_destination, :user_id, :id]
  defstruct [:inserted_at, :updated_at] ++ @enforce_keys

  def build(%NaiveDateTime{} = complete_date, local_origin, local_destination, user_id) do
   {:ok, %__MODULE__{
      complete_date: complete_date,
      id: UUID.uuid4(),
      local_origin: local_origin,
      local_destination: local_destination,
      user_id: user_id,
      inserted_at: NaiveDateTime.utc_now()
    }}
  end
end

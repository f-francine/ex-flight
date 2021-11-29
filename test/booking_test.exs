defmodule ExFlight.UserTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExFlight.Agents.BookingAgent
  alias ExFlight.Agents.UserAgent
  alias ExFlight.Booking
  alias ExFlight.User
  alias ExFlight.Types.Booking, as: Input

  setup do
    UserAgent.start_link(%{})
    BookingAgent.start_link(%{})
    :ok
  end

  describe "create/1" do
    test "Succeeds in creating a booking" do
      name = "Amy Santiago"
      email = "amy.santiago@99precinct.com"
      cpf = "09084573782"

      {:ok, user} = User.create(name, email, cpf)

      complete_date = ~N[2001-05-07 03:05:00]
      local_origin = "Brasilia"
      local_destination = "Bananeiras"
      user_id = user.id

      assert {:ok,
              %Input{
                complete_date: ~N[2001-05-07 03:05:00],
                inserted_at: %NaiveDateTime{},
                local_destination: "Bananeiras",
                local_origin: "Brasilia",
                user_id: ^user_id
              }} = Booking.create(complete_date, local_origin, local_destination, user_id)
    end
  end
end

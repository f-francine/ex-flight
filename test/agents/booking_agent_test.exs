defmodule ExFlight.Agents.BookingAgentTest do
  @moduledoc false

  use ExUnit.Case

  import ExFlight.Factory

  alias ExFlight.Agents.BookingAgent
  alias ExFlight.Agents.UserAgent
  alias ExFlight.Types.Booking

  setup do
    BookingAgent.start_link(%{})
    UserAgent.start_link(%{})

    :ok
  end

  describe "insert/1" do
    test "when the params are valid, returns a booking uuid" do
      response =
        :booking
        |> build()
        |> BookingAgent.insert()

      assert {:ok, booking_id} = response
      assert is_binary(booking_id) == true
    end
  end

  describe "get/1" do
    test "Returns a booking" do
      {:ok, user_id} =
        :user
        |> build()
        |> UserAgent.insert()

      {:ok, booking_id} =
        :booking
        |> build(user_id: user_id)
        |> BookingAgent.insert()

      response = BookingAgent.get(booking_id)

      expected_response =
        {:ok,
         %Booking{
           complete_date: ~N[2001-05-07 03:05:00],
           id: booking_id,
           local_destination: "Bananeiras",
           local_origin: "Brasilia",
           user_id: user_id
         }}

      assert response == expected_response
    end

    test "when the user wasn't found, returns an error" do
      {:ok, booking_id} =
        :booking
        |> build()
        |> BookingAgent.insert()

      response = BookingAgent.get(UUID.uuid4())

      expected_response = {:error, :not_found}

      assert response == expected_response
    end
  end
end

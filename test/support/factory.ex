defmodule ExFlight.Factory do
  use ExMachina

  alias ExFlight.Types.Booking
  alias ExFlight.Types.User

  def user_factory do
    %User{
      id: UUID.uuid4(),
      name: "Amy Santiago",
      email: "amy.santiago@99precinct.com",
      cpf: "12345678900"
    }
  end

  def booking_factory do
    %Booking{
      complete_date: ~N[2001-05-07 03:05:00],
      local_origin: "Brasilia",
      local_destination: "Bananeiras",
      user_id: "12345678900",
      id: UUID.uuid4()
    }
  end
end

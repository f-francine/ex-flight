defmodule ExFlight.Types.UserTest do
  @moduledoc false

  use ExUnit.Case

  alias ExFlight.Types.User

  import ExFlight.Factory

  describe "build/3" do
    test "Succeeds in generating an user struct" do
      assert {:ok, _} =
               User.build(
                 "Amy Santiago",
                 "amy.santiago@99precinct.com",
                 "12345678910"
               )
    end

    test "Fails if email is not valid" do
      assert User.build(
               "Amy Santiago",
               "amy.santiago.com",
               "123"
             ) == {:error, :invalid_email}
    end

    test "Fails if cpf is not valid" do
      assert User.build(
               "Amy Santiago",
               "amy.santiago@99precinct.com",
               "123"
             ) == {:error, :invalid_cpf}
    end
  end
end

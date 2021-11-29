defmodule ExFlight.Agents.AgentTest do
  @moduledoc false
  
  use ExUnit.Case

  import ExFlight.Factory

  alias ExFlight.Agents.UserAgent

  setup do
    UserAgent.start_link(%{})
    :ok
  end

  describe "insert/1" do
    test "Succeeds in inserting an user" do
      cpf = "09855689807"

      assert {:ok, id} =
               :user
               |> build(cpf: cpf)
               |> UserAgent.insert()

      assert is_binary(id) == true
    end
  end

  describe "get/1" do
    test "Succeeds in geetting an user by id" do
      cpf = "09856478798"

      {:ok, id} =
        :user
        |> build(cpf: cpf)
        |> UserAgent.insert()

      assert UserAgent.get(id) ==
               {:ok,
                %ExFlight.Types.User{
                  cpf: cpf,
                  email: "amy.santiago@99precinct.com",
                  id: id,
                  name: "Amy Santiago"
                }}
    end

    test "Returns an error when user does not existis" do
      assert UserAgent.get(UUID.uuid4()) == {:error, :not_found}
    end
  end
end

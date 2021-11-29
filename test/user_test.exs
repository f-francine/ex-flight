defmodule ExFlight.UserTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExFlight.Agents.UserAgent
  alias ExFlight.Types.User, as: Input
  alias ExFlight.User

  setup do
    UserAgent.start_link(%{})
    :ok
  end

  describe "create/1" do
    test "Succeeds in creating an user" do
      name = "Amy Santiago"
      email = "amy.santiago@99precinct.com"
      cpf = "09084573782"

      assert {:ok,
              %Input{
                cpf: ^cpf,
                email: ^email,
                id: id,
                name: ^name,
                inserted_at: %NaiveDateTime{}
              }} = User.create(name, email, cpf)

      assert is_binary(id) == true
    end

    test "Fails if yhe given input is invalid" do
      name = "Amy Santiago"
      email = "amy.santiago@99precinct.com"
      cpf = "09"

      assert User.create(name, email, cpf) == {:error, :invalid_input}
    end
  end

  describe "update/2" do
    test "Succeeds in updating an user" do
      name = "Amy Santiago"
      email = "amy.santiago@99precinct.com"
      cpf = "09084573782"

      {:ok, user} = User.create(name, email, cpf)

      params = %{email: "amy@brooklyn99.com"}
      updated_email = params.email

      assert {:ok,
              %Input{
                cpf: ^cpf,
                email: ^updated_email,
                id: user_id,
                inserted_at: %NaiveDateTime{},
                name: ^name,
                updated_at: %NaiveDateTime{}
              }} = User.update(user.id, params)

      assert user_id == user.id
    end

    test "Ensures user's id is not updated even when it is passed on params" do
      name = "Amy Santiago"
      email = "amy.santiago@99precinct.com"
      cpf = "09084573782"

      {:ok, user} = User.create(name, email, cpf)

      params = %{email: "amy@brooklyn99.com", id: "123"}
      updated_email = params.email

      assert {:ok,
              %Input{
                cpf: ^cpf,
                email: ^updated_email,
                id: user_id,
                inserted_at: %NaiveDateTime{},
                name: ^name,
                updated_at: %NaiveDateTime{}
              }} = User.update(user.id, params)

      assert user_id == user.id
    end

    test "Fails if user does not existis" do
      params = %{email: "amy@brooklyn99.com"}

      assert {:error, :not_found} == User.update(UUID.uuid4(), params)
    end
  end
end

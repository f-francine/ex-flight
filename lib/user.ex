defmodule ExFlight.User do
  @moduledoc """
  Validates the user input and when it is valid, inserts the user.
  """

  require Logger

  alias ExFlight.Types.User
  alias ExFlight.Agents.UserAgent

  @spec create(name :: String.t(), email :: String.t(), cpf :: String.t()) ::
          {:ok, map()} | {:error, :invalid_email | :invalid_cpf}
  def create(name, email, cpf) do
    with {:ok, user} <- User.build(name, email, cpf),
         {:ok, user_id} <- UserAgent.insert(user) do
      Logger.info("User #{user_id} successfully created.")
      {:ok, user}
    else
      {:error, :invalid_email} ->
        Logger.info("Failed due to invalid email.")
        {:error, :invalid_input}

      {:error, :invalid_cpf} ->
        Logger.info("Failed due to invalid email.")
        {:error, :invalid_input}
    end
  end

  @spec update(user :: %User{}, params :: map()) ::
          {:ok, map()} | {:error, :not_found | :invalid_input}
  def update(user_id, params) do
    params = maybe_drop_id(params)

    with {:ok, user} <- UserAgent.get(user_id),
         {:ok, _} <- UserAgent.insert(do_update(user, params)) do
      Logger.info("User successfully updated.")
      get(user_id)
    else
      {:error, :not_found} = error ->
        Logger.error("Failed due to user not found.")
        error

      {:error, :invalid_email} ->
        Logger.info("Failed due to invalid email.")
        {:error, :invalid_input}

      {:error, :invalid_cpf} ->
        Logger.info("Failed due to invalid email.")
        {:error, :invalid_input}
    end
  end

  defp do_update(user, params) do
    user
    |> Map.merge(params)
    |> Map.merge(%{updated_at: NaiveDateTime.utc_now()})
  end

  @spec get(user_id :: String.t()) :: {:ok, map()} | {:error, :not_found}
  def get(user_id) do
    Logger.info("Getting user #{user_id}.")

    case UserAgent.get(user_id) do
      {:ok, _user} = result ->
        result

      {:error, :not_found} = error ->
        Logger.error("Failed due to user not found.")
        error
    end
  end

  defp maybe_drop_id(%{id: _id} = params), do: Map.drop(params, [:id])
  defp maybe_drop_id(params), do: params
end

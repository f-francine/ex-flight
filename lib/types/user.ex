defmodule ExFlight.Types.User do
  @moduledoc """
  Defines the user struct and validates the given input.
  """

  @enforce_keys [:name, :email, :cpf, :id]
  defstruct [:inserted_at, :updated_at] ++ @enforce_keys

  @doc """
  Validates the user input and generates a struct.
  """
  @spec build(name :: String.t(), email :: String.t(), cpf :: String.t()) :: {:ok, map()}
  def build(name, email, cpf) do
    with {:email, true} <- {:email, valid_email?(email)},
         {:cpf, true} <- {:cpf, valid_cpf?(cpf)} do
      {:ok,
       %__MODULE__{
         cpf: cpf,
         email: email,
         id: UUID.uuid4(),
         name: name,
         inserted_at: NaiveDateTime.utc_now()
       }}
    else
      {:email, false} -> {:error, :invalid_email}
      {:cpf, false} -> {:error, :invalid_cpf}
    end
  end

  defp valid_cpf?(cpf), do: String.length(cpf) == 11

  defp valid_email?(email), do: Regex.match?(~r|.*@.*|, email)
end

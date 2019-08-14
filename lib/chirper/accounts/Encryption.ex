defmodule Chirper.Accounts.Encryption do
  alias Bcrypt
  alias Chirper.Accounts.User

  def hash_password(password), do: Bcrypt.hash_pwd_salt(password)

  def validate_password(%User{} = user, hash) do
    result = Bcrypt.verify_pass(hash, user.encrypted_password)
    case result do
      true ->  {:ok, user}
      _ -> {:error, "invalid password"} 
    end
  end
end

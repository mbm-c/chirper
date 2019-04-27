defmodule Chirper.Accounts.Encryption do
  alias Comeonin.Bcrypt
  alias Chirper.Accounts.User

  def hash_password(password), do: Bcrypt.hashpwsalt(password)
  def validate_password(%User{} = user, hash), do: Bcrypt.check_pass(user, hash)
end

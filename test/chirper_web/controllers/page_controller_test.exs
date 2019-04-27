defmodule ChirperWeb.PageControllerTest do
  use ChirperWeb.ConnCase

  alias Chirper.Accounts

  @valid_attrs %{encrypted_password: "some encrypted_password", username: "some username"}
  @valid_login %{password: "some encrypted_password", username: "some username"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

      user
  end

  test "GET / redirects to login if not logged in", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn) == Routes.session_path(conn, :new)
  end

  test "GET / doesn't redirects to login if user logged in", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn) == Routes.session_path(conn, :new)

    user = user_fixture()

    conn = post(conn, Routes.session_path(conn, :create), session: @valid_login)
    assert redirected_to(conn) == Routes.page_path(conn, :show)
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    assert user_id == user.id
    assert user == Accounts.get_user!(user_id)

    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Logout"
  end
end

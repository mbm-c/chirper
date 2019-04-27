defmodule ChirperWeb.SessionControllerTest do
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

  # describe "new user" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.session_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New User"
  #   end
  # end

  describe "login" do
    test "fail if there is no user registered",  %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @valid_login)
      assert html_response(conn, 200) =~ "There was a problem with your username/password"
    end

    test "success if the user is registered", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, Routes.session_path(conn, :create), session: @valid_login)
      assert redirected_to(conn) == Routes.page_path(conn, :show)
      user_id = Plug.Conn.get_session(conn, :current_user_id)
      assert user_id == user.id
      assert user == Accounts.get_user!(user_id)
    end
  end

  describe "logout" do
    test "should logout, logged in user", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, Routes.session_path(conn, :create), session: @valid_login)
      assert redirected_to(conn) == Routes.page_path(conn, :show)
      user_id = Plug.Conn.get_session(conn, :current_user_id)
      assert user_id == user.id
      assert user == Accounts.get_user!(user_id)

      conn = delete(conn, Routes.session_path(conn, :delete))
      assert redirected_to(conn) == Routes.session_path(conn, :new)
      user_id = Plug.Conn.get_session(conn, :current_user_id)
      assert user_id == nil
    end
  end
end

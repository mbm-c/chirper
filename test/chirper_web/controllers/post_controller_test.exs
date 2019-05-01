defmodule ChirperWeb.PostControllerTest do
  use ChirperWeb.ConnCase

  alias Chirper.Blog
  alias Chirper.Accounts

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  # For user login
  @valid_attrs %{password: "some encrypted_password", password_confirmation: "some encrypted_password", username: "some username"}
  @valid_login %{password: "some encrypted_password", username: "some username"}


  def fixture(:post) do
    user = user_fixture()
    {:ok, post} = Blog.create_post(user, @create_attrs)
    post
  end

  def user_fixture(attrs \\ %{}) do
    user = Accounts.get_by_username(@valid_attrs[:username])
    case user do
      nil ->
        {:ok, new_user} =
          attrs
          |> Enum.into(@valid_attrs)
          |> Accounts.create_user()
        Accounts.get_user!(new_user.id)
      _ ->
        user
    end
  end

  def login_users(conn) do
    user = user_fixture()

    conn = post(conn, Routes.session_path(conn, :create), session: @valid_login)
    assert redirected_to(conn) == Routes.page_path(conn, :show)
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    assert user.id == user_id
    assert user == Accounts.get_user!(user_id)
    conn
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = login_users(conn)
      post = fixture(:post)
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ post.title
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = login_users(conn)
      conn = get(conn, Routes.post_path(conn, :new))
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = login_users(conn)

      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ @create_attrs[:title]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = login_users(conn)

      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = login_users(conn)

      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = login_users(conn)

      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = login_users(conn)

      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = login_users(conn)

      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.post_path(conn, :index)
      get(conn, Routes.post_path(conn, :show, post))
      assert redirected_to(conn) == Routes.post_path(conn, :index)
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end

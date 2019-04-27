defmodule ChirperWeb.Router do
  use ChirperWeb, :router

  alias Chirper.Accounts

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :check_auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChirperWeb do
    pipe_through :browser

    get "/", SessionController, :new
    resources "/user", UserController, only: [:create, :new]
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end

  scope "/", ChirperWeb do
    pipe_through :browser_auth

    get "/show", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChirperWeb do
  #   pipe_through :api
  # end

  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)
      conn
        |> assign(:current_user, current_user)
    else
      conn
        |> put_flash(:error, "You need to be signed in to access that page.")
        |> redirect(to: "/")
        |> halt()
    end
  end
end

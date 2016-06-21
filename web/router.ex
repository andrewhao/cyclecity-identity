defmodule VelocitasIdentity.Router do
  use VelocitasIdentity.Web, :router

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VelocitasIdentity do
    pipe_through [:api]
  end

  scope "/", VelocitasIdentity do
    pipe_through [:browser]

    resources "/users", UserController
  end

  scope "/", VelocitasIdentity do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
  end

  scope "/auth", VelocitasIdentity do
    pipe_through :browser
    post "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", VelocitasIdentity do
  #   pipe_through :api
  # end
end

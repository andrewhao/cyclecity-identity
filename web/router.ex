defmodule VelocitasIdentity.Router do
  use VelocitasIdentity.Web, :router

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
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
  end

  scope "/auth", VelocitasIdentity do
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callbac
  end

  # Other scopes may use custom stacks.
  # scope "/api", VelocitasIdentity do
  #   pipe_through :api
  # end
end

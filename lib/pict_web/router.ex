defmodule PictWeb.Router do
  use PictWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PictWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PictWeb do
    pipe_through :browser

    live "/submissions/:id", SubmissionLive.Show, :show
    live "/submissions/:id/edit", SubmissionLive.Show, :edit
    resources "/games", GameController, only: [:new, :create]
    get "/games/pending", GameController, :pending
    get "/games/:admin_id", GameController, :admin
    get "/games/:admin_id/confirm", GameController, :confirm
    post "/games/:admin_id/start", GameController, :start
    post "/games/:admin_id/prompts/:prompt_id/reminder", GameController, :reminder
  end

  # Other scopes may use custom stacks.
  # scope "/api", PictWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Application.compile_env(:pict, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

    live_dashboard "/dashboard", metrics: PictWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

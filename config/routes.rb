Rails.application.routes.draw do
  # Non Sufia generated routes
  mount ProductionCredits::Engine, at: "/production_credits"

  # Sufia generated routes
  blacklight_for :catalog
  devise_for :users
  Hydra::BatchEdit.add_routes(self)
  # This must be the very last route in the file because it has a catch-all route for 404 errors.
    # This behavior seems to show up only in production mode.
  mount Sufia::Engine => "/"

  resources :searches

  get "/images", to: "searches#images"
  get "/articles", to: "searches#articles"
  get "/videos", to: "searches#videos"
  get "/audios", to: "searches#audios"

  root to: "homepage#index"
end

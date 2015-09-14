Rails.application.routes.draw do
  # Non Sufia generated routes
  mount ProductionCredits::Engine, at: "/production_credits"

  # Sufia generated routes
  blacklight_for :catalog

  scope "/admin" do
    devise_for :users
  end

  Hydra::BatchEdit.add_routes(self)

  # This must be the very last route in the file because it has a catch-all
  # route for 404 errors.
  # This behavior seems to show up only in production mode.
  mount Sufia::Engine => "/admin"

  resources :searches

  get "/images", to: "searches#images"
  get "/articles", to: "searches#articles"
  get "/videos", to: "searches#videos"
  get "/audios", to: "searches#audios"

  get "about" => "cms_pages#show", id: "about_page"
  get "policies" => "cms_pages#show", id: "policies_page"

  # For editing via the Sufia backend
  get "admin/policies" => "pages#show", id: "policies_page"

  root to: "searches#index"
end

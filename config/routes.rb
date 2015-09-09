Rails.application.routes.draw do
  # Non Sufia generated routes
  mount ProductionCredits::Engine, at: "/production_credits"

  # Sufia generated routes
  blacklight_for :catalog
  devise_for :users
  Hydra::BatchEdit.add_routes(self)
  # This must be the very last route in the file because it has a catch-all route for 404 errors.
    # This behavior seems to show up only in production mode.
  mount Sufia::Engine => '/'

  resources :searches

  get "public_about" => 'cms_pages#show', id: 'about_page'
  get "policies" => 'cms_pages#show', id: 'policies_page'

  # For editing via the Sufia backend
  get "admin/policies" => 'pages#show', id: 'policies_page'

  root to: 'homepage#index'
end

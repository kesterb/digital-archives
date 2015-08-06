ProductionCredits::Engine.routes.draw do
  root to: 'homepage#index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  match 'works' => 'works#index', via: [:get, :post]
end

ProductionCredits::Engine.routes.draw do
  root to: 'homepage#index'
  match 'works' => 'works#index', via: [:get, :post]
end

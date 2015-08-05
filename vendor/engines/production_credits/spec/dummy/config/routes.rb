Rails.application.routes.draw do

  mount ProductionCredits::Engine => "/production_credits"
end

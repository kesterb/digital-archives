module Observers
  class ProductionObserver < ActiveRecord::Observer
    observe ProductionCredits::Production

    def after_commit(production)
    end
  end
end

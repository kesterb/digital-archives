module Observers
  class WorkObserver < ActiveRecord::Observer
    observe ProductionCredits::Work

    def after_commit(work)
    end
  end
end

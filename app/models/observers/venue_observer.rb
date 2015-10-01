module Observers
  class VenueObserver < ActiveRecord::Observer
    observe ProductionCredits::Venue

    def after_commit(venue)
    end
  end
end

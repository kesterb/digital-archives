module Observers
  class EventTypeObserver < ActiveRecord::Observer
    observe ProductionCredits::EventType

    def after_commit(event_type)
    end
  end
end

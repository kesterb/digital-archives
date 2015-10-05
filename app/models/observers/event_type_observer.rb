module Observers
  class EventTypeObserver < ProductionCreditsObserver
    observe ProductionCredits::EventType

    private

    def attributes_to_watch
      %i[name]
    end

    def new_update_job(event_type)
      UpdateGenericFileForEventTypeJob.new(event_type)
    end
  end
end

module Observers
  class EventTypeObserver < ProductionCreditsObserver
    observe ProductionCredits::EventType

    private

    def attribute_to_watch
      :name
    end

    def new_update_job(event_type)
      UpdateGenericFileForEventTypeJob.new(event_type)
    end
  end
end

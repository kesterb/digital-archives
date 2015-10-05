module Observers
  class EventTypeObserver < ProductionCreditsObserver
    observe ProductionCredits::EventType

    private

    def new_update_job(event_type)
      UpdateGenericFileForEventTypeJob.new(event_type)
    end

    def attribute_to_watch
      :name
    end
  end
end

module Observers
  class EventTypeObserver < ActiveRecord::Observer
    observe ProductionCredits::EventType

    def after_commit(event_type)
      return if new_record?(event_type)
      return unless has_relevant_changes?(event_type)

      Sufia.queue.push(UpdateGenericFileForEventTypeJob.new(event_type))
    end

    private

    def new_record?(event_type)
      event_type.previous_changes.key?(:id)
    end

    def has_relevant_changes?(event_type)
      event_type.previous_changes.key?(:name)
    end
  end
end

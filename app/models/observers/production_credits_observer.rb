module Observers
  class ProductionCreditsObserver < ActiveRecord::Observer
    def after_commit(record)
      return if new_record?(record)
      return unless has_relevant_changes?(record)

      Sufia.queue.push(new_update_job(record))
    end

    private

    def new_record?(record)
      record.previous_changes.key?(:id)
    end

    def has_relevant_changes?(record)
      record.previous_changes.key?(attribute_to_watch)
    end

    def new_update_job(record)
      fail NotImplementedError, "Subclasses must implement :new_update_job"
    end

    def attribute_to_watch
      fail NotImplementedError, "Subclasses must implement :attribute_to_watch"
    end
  end
end

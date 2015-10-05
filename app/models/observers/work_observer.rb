module Observers
  class WorkObserver < ActiveRecord::Observer
    observe ProductionCredits::Work

    def after_commit(work)
      return if new_record?(work)
      return unless has_relevant_changes?(work)

      Sufia.queue.push(UpdateGenericFileForWorkJob.new(work))
    end

    private

    def new_record?(work)
      work.previous_changes.key?(:id)
    end

    def has_relevant_changes?(work)
      work.previous_changes.key?(:title)
    end
  end
end

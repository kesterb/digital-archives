module Observers
  class WorkObserver < ProductionCreditsObserver
    observe ProductionCredits::Work

    private

    def attributes_to_watch
      %i[title]
    end

    def new_update_job(work)
      UpdateGenericFileForWorkJob.new(work)
    end
  end
end

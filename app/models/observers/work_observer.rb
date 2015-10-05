module Observers
  class WorkObserver < ProductionCreditsObserver
    observe ProductionCredits::Work

    private

    def attribute_to_watch
      :title
    end

    def new_update_job(work)
      UpdateGenericFileForWorkJob.new(work)
    end
  end
end

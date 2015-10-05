module Observers
  class WorkObserver < ProductionCreditsObserver
    observe ProductionCredits::Work

    private

    def new_update_job(work)
      UpdateGenericFileForWorkJob.new(work)
    end

    def attribute_to_watch
      :title
    end
  end
end

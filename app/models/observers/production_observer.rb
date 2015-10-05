module Observers
  class ProductionObserver < ProductionCreditsObserver
    observe ProductionCredits::Production

    private

    def attribute_to_watch
      :production_name
    end

    def new_update_job(production)
      UpdateGenericFileForProductionJob.new(production)
    end
  end
end

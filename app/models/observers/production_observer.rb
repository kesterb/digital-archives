module Observers
  class ProductionObserver < ProductionCreditsObserver
    observe ProductionCredits::Production

    private

    def attributes_to_watch
      %i[production_name]
    end

    def new_update_job(production)
      UpdateGenericFileJob.for_production(production)
    end
  end
end

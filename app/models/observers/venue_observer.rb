module Observers
  class VenueObserver < ProductionCreditsObserver
    observe ProductionCredits::Venue

    private

    def attribute_to_watch
      :name
    end

    def new_update_job(venue)
      UpdateGenericFileForVenueJob.new(venue)
    end
  end
end

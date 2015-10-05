module Observers
  class VenueObserver < ProductionCreditsObserver
    observe ProductionCredits::Venue

    private

    def attributes_to_watch
      %i[name canonical_venue_id]
    end

    def new_update_job(venue)
      UpdateGenericFileForVenueJob.new(venue)
    end
  end
end

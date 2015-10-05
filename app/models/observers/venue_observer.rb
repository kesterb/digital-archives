module Observers
  class VenueObserver < ProductionCreditsObserver
    observe ProductionCredits::Venue

    private

    def queue_jobs_for(venue)
      super

      venue.aliases.each do |venue_alias|
        queue_update_job_for(venue_alias)
      end
    end

    def attributes_to_watch
      %i[name canonical_venue_id]
    end

    def new_update_job(venue)
      UpdateGenericFileForVenueJob.new(venue)
    end
  end
end

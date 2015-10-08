module ProductionCredits
  class VenuesController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_filter :authenticate_user!

    def index
      venues = Venue
        .joins(:productions)
        .where(production_credits_productions: { id: params[:production_ids] })
      venues = Venue.all if venues.empty?
      render json: venues, layout: false
    end
  end
end

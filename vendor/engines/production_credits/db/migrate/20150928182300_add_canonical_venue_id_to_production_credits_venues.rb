class AddCanonicalVenueIdToProductionCreditsVenues < ActiveRecord::Migration
  def change
    add_reference :production_credits_venues, :canonical_venue, references: :venues, index: true
  end
end

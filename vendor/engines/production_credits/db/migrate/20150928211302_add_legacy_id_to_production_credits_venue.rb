class AddLegacyIdToProductionCreditsVenue < ActiveRecord::Migration
  def change
    add_column :production_credits_venues, :legacy_id, :integer
  end
end

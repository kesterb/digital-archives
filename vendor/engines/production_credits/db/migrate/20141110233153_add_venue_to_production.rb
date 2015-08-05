class AddVenueToProduction < ActiveRecord::Migration
  def change
    add_reference :production_credits_productions, :venue, index: true
    add_column :production_credits_productions, :venue_alias, :string
  end
end

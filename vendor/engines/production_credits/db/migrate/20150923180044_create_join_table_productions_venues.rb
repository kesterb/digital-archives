class CreateJoinTableProductionsVenues < ActiveRecord::Migration
  def change
    create_table :production_credits_productions_venues, id: false do |t|
      t.references :production
      t.references :venue
      t.index [:production_id, :venue_id], name: :index_productions_venues
      t.index [:venue_id, :production_id], name: :index_venues_productions
    end

    remove_reference :production_credits_productions, :venue, index: true
  end
end

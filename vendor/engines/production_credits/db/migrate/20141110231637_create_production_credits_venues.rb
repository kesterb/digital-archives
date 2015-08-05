class CreateProductionCreditsVenues < ActiveRecord::Migration
  def change
    create_table :production_credits_venues do |t|
      t.string :name
      t.timestamps
    end
  end
end

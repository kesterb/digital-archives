class AddLegacyIdToProductionCreditsProductions < ActiveRecord::Migration
  def change
    add_column :production_credits_productions, :legacy_id, :integer
  end
end

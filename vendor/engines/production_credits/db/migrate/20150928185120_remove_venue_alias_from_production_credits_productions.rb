class RemoveVenueAliasFromProductionCreditsProductions < ActiveRecord::Migration
  def change
    remove_column :production_credits_productions, :venue_alias, :string
  end
end

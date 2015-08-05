class RemoveMediumFromWork < ActiveRecord::Migration
  def change
    remove_column :production_credits_works, :medium
  end
end

class CreateProductionCreditsEventTypes < ActiveRecord::Migration
  def change
    create_table :production_credits_event_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

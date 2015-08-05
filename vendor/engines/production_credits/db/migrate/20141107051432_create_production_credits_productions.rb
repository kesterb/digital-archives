class CreateProductionCreditsProductions < ActiveRecord::Migration
  def change
    create_table :production_credits_productions do |t|
      t.string :production_name
      t.string :category
      t.date :open_on
      t.date :close_on
    end
  end
end

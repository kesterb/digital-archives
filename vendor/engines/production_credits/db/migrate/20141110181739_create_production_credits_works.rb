class CreateProductionCreditsWorks < ActiveRecord::Migration
  def change
    create_table :production_credits_works do |t|
      t.string :title
      t.string :author
      t.string :medium
      t.date :year_written
      t.text :description
      t.timestamps
    end

    add_reference :production_credits_productions, :work, index: true
  end
end

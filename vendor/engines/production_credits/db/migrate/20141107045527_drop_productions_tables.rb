class DropProductionsTables < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.table_exists? :production_credits_works
      drop_table :production_credits_works
    end

    if ActiveRecord::Base.connection.table_exists? :production_credits_productions
      drop_table :production_credits_productions
    end

    if ActiveRecord::Base.connection.table_exists? :production_credits_credits
      drop_table :production_credits_credits
    end

    if ActiveRecord::Base.connection.table_exists? :production_credits_roles
      drop_table :production_credits_roles
    end

    if ActiveRecord::Base.connection.table_exists? :production_credits_people
      drop_table :production_credits_people
    end

    if ActiveRecord::Base.connection.table_exists? :production_credits_performances
      drop_table :production_credits_performances
    end

    if ActiveRecord::Base.connection.table_exists? :production_credits_venues
      drop_table :production_credits_venues
    end
    
    if ActiveRecord::Base.connection.table_exists? :production_credits_names
      drop_table :production_credits_names
    end
    
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

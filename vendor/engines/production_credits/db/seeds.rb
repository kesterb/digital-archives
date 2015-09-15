module ProductionCredits
  unless Rails.env.production?
    connection = ActiveRecord::Base.connection

    tables = %w(production_credits_works production_credits_venues production_credits_productions)
    tables.each do |table|
      connection.execute("DELETE FROM #{table}")
    end

    connection.execute("VACUUM")

    sql = File.read('vendor/engines/production_credits/db/seed_data/production_credits.sql')
    statements = sql.split(/;$/)
    statements.pop

    ActiveRecord::Base.transaction do
      statements.each do |statement|
        connection.execute(statement)
      end
    end
  end
end

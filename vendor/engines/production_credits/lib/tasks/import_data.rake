require 'date'
require 'csv'
require 'set'
require 'pp'
namespace :production_credits do
  desc 'import data'
  task :import_data, [:authors, :corporate, :venues, :person_alias, :person, :production, :assignment, :roles, :year] => :environment do |t, args|

#### INITIALIZATION

    @timestamp = DateTime.now().strftime("%Y-%m-%d %H:%M:%S.%6N")

    authors_csv = CSV.open(args[:authors], {:headers => true})
    corporate_csv = CSV.open(args[:corporate], {:headers => true})
    venues_csv = CSV.open(args[:venues], { :headers => true })
    person_alias_csv = CSV.open(args[:person_alias], { :headers => true })
    person_csv = CSV.open(args[:person], { :headers => true })
    production_csv = CSV.open(args[:production], { :headers => true })
    assignment_csv = CSV.open(args[:assignment], { :headers => true })
    roles_csv = CSV.open(args[:roles], { :headers => true })
    year_csv = CSV.open(args[:year], { :headers => true })

    #production = []

    def process_venues(venues_csv)
      # declare temporary storage array
      venues = {}
      venues_csv.each do |row|
        unless row.empty?
          create_venue(row['Location ID'], row['Location'])
          # append venue object to array of venues
          venues.merge!(Hash[row['Location ID'], ProductionCredits::Venue.find_by( id: row['Location ID'])])
        end
      end

      # return a hash of venue objects and their id
      #venues = Hash[temp_venues.map{ |venue| [venue.attributes['id'] => venue] }]
      return venues
    end

    def create_venue(venue_id, venue_name)
      sql_str = "insert into production_credits_venues (id, name, created_at, updated_at) values (#{venue_id}, \"#{venue_name}\", \"#{@timestamp}\", \"#{@timestamp}\")"
      ProductionCredits::Venue.connection.execute(sql_str)
    end

    def process_works(productions_csv)
      works = {}
      #uniq_works = get_uniq_productions(productions_csv)
      uniq_works = get_productions(productions_csv, true)
      uniq_works.each do |work|
        work = create_work(work)
        works.merge!(Hash[work.attributes['id'] => work])
      end

      #works = Hash[ ProductionCredits::Work.all.map { |work| [work.attributes['id'] => work ] } ]
      return works
    end

    def create_work(production_name)
      # since this is not represented in the current schema we can create the objects normally
      ProductionCredits::Work.create(title: production_name)
    end

    #def get_uniq_productions(production_csv)
    def get_productions(production_csv, unique)
      temp_productions = []
      temp_productions_hash = {}
      production_csv.each do |row|
        unless row.empty?
          if unique
            temp_productions << row['Production Name']
          else
            #puts row['Production ID'] + row['Production Name']
            temp_productions_hash.merge!(row['Production ID'] => row['Production Name'])
          end
        end
      end

      if unique
        return temp_productions.uniq!
      else
        return temp_productions_hash
      end
    end

    def uniq_assignments(assignment_csv)
      assignment_set = Set.new
      assignments = []
      assignment_csv.each do |row|
        unless row.empty?
          assign = { location_id:  row['Location ID'], production_id: row['Production ID'], year_id: row['Done ID']}
          unless assignment_set.include? assign
            assignment_set.add( assign )
            assignments << {location_id:  row['Location ID'],
              production_id: row['Production ID'],
              year_id: row['Done ID'],
              assignment_id: row['Assign ID']}
          end
        end
      end
      return assignments
    end

    # TODO: refactor
    # Input is a string, here we try and catch all cases present in dataset
    def process_years(year_csv)
      years = {}
      year_csv.each do |row|
        year_id = row['Year ID']
        open_close_hash = split_year(row['Year'])
        years.merge!( year_id => open_close_hash )
      end
      return years
    end

    # TODO: refactor
    # Abandon hope all ye who enter
    # example dates: YYYY
    #                YYYY Month
    #                YYYY Month dd
    #                YYYY Month dd, dd
    #                YYYY Month-Month
    #                YYYY Season
    #                YYYY Season/Season
    #                YYYY (Concert Series) ...
    # expect 0 to many white space

    def split_year(year_string)
      # grab the year from the string
      year_int = year_string.to_i
      # remove the year digits we've processed
      year_string = year_string[4,year_string.length]

      # check if the remaining string is empty, garage, or whitespace and return if it is
      if year_string.length == 0 || year_string.include?("(Concert Series)") || year_string =~ /^\s*$/
        return Hash['open_on', "#{year_int}-01-01", 'close_on', "#{year_int}-12-31"]
      else
        # match for WORD / WORD or WORD - WORD or WORD, WORD
        match = year_string.match(/\s*([A-Za-z]+)(\s*\/\s*|\s*-\s*|\s*,\s*)([A-Za-z]+)/)
        if !match.nil?
          return parse_year(year_int, match)
        end

        # match for MONTH_WORD DAY, DAY
        match = year_string.match(/\s*([A-Za-z]+)(\s*)(\d{2})(\s*|\s*,\s*)(\d{2})/)
        if !match.nil?
          return parse_year(year_int, match)
        end

        # match for MONTH_WORD DAY
        match = year_string.match(/\s*([A-Za-z]+)(\s*)(\d{2})/)
        if !match.nil?
          return parse_year(year_int, match)
        end

        # match for , MONTH_WORD
        match = year_string.match(/\s*,*\s*([A-Za-z]+)\s*/)
        if !match.nil?
          return parse_year(year_int, match)
        else
          # no additonal valid data found, fallback to just year
          return Hash['open_on', "#{year_int}-01-01", 'close_on', "#{year_int}-12-31"]
        end
      end
    end

    def parse_year(year_int, match)
      # determine if we're dealing with months/seasons, or days
      if match[1] =~ /^[A-Za-z]*$/
        start_word = match[1]
      else
        start_word = nil
      end

      if match[3] =~ /^[A-Za-z]*$/
        end_word = match[3]
      else
        end_word = nil
      end
      if match[3] =~ /^\d*$/
        start_day = match[3]
      else
        start_day = nil
      end
      if match[5] =~ /^\d*$/
        end_day = match[5]
      else
        end_day = nil
      end

      seasons = ["winter","spring","summer","fall"]

      # check if first word is a season
      # TODO: pull season for year in question, need year passed down
      # ---------------------
      # approximate seasons
      # fall sept 22- dec 20
      # winter dec 21 mar 19
      # spring mar 20 - jun 20
      # summer jun 21- sept 21
      # ---------------------
      if seasons.any? { |season| start_word.downcase.include?(season)}
        case start_word.downcase
          when "winter"
            open_on = "#{year_int}-12-21"
          when "spring"
            open_on = "#{year_int}-03-20"
          when "summer"
            open_on = "#{year_int}-06-21"
          when "fall"
            open_on = "#{year_int}-09-21"
        end
        # check if we have 2 seasons or one
        if end_word.nil?
          end_word = start_word.downcase
        else
          end_word = end_word.downcase
        end
        # check if the second word is in fact a season
        case end_word
          when "winter"
            close_on = "#{year_int}-03-19"
          when "spring"
            close_on = "#{year_int}-06-20"
          when "summer"
            close_on = "#{year_int}-09-19"
          when "fall"
            close_on = "#{year_int}-12-20"
        end

      # seasons processed
      # if only one month, and no days
      elsif !start_word.nil? && end_word.nil? && start_day.nil? && end_day.nil?
        open_on  = Date.civil(year_int, Date::MONTHNAMES.index(start_word),  1).to_s
        close_on = Date.civil(year_int, Date::MONTHNAMES.index(start_word), -1).to_s

      # have 2 months information
      elsif !start_word.nil? && !end_word.nil?
        open_on  = Date.civil(year_int, Date::MONTHNAMES.index(start_word),  1).to_s
        close_on = Date.civil(year_int, Date::MONTHNAMES.index(end_word  ), -1).to_s

      # handle month + 2 dates
      elsif !start_word.nil? && !start_day.nil? && !end_day.nil?
        open_on   = Date.civil(year_int, Date::MONTHNAMES.index(start_word),  start_day.to_i).to_s
        close_on  = Date.civil(year_int, Date::MONTHNAMES.index(start_word),  end_day.to_i).to_s

      # handle month + 1 dates
      elsif !start_word.nil? && !start_day.nil?
        open_on = close_on = Date.civil(year_int, Date::MONTHNAMES.index(start_word),  start_day.to_i).to_s

      # fall back to only year and notify
      else
        # TODO: notify user of fallback w/ appropriate id's
        open_on = "#{year_int}-01-01"
        close_on = "#{year_int}-12-31"
      end

      # finally send back our two values
      open_close_hash = Hash['open_on', open_on, 'close_on', close_on]

      return open_close_hash

    end # parse year


    def process_productions(production_csv, uniq_assign, works, venues, years)
      all_prods = get_productions(production_csv, false)
      prods = []
      uniq_assign.each do |assign|
        unless assign.empty?
          if venues[assign[:location_id].to_s].nil?
            #TODO: log to file
            puts "skipping record with nil venue => location_id: #{assign[:location_id]} production_id: #{assign[:production_id]} year_id: #{assign[:year_id]}"
          #elsif works[assign[:production_id].to_i].nil?
          elsif ProductionCredits::Work.find_by_title(all_prods[assign[:production_id]]).nil?
            #TODO: log to file
            puts "skipping record with nil works => location_id: #{assign[:location_id]} production_id: #{assign[:production_id]} year_id: #{assign[:year_id]}"
          elsif years[assign[:year_id]].nil?
            #TODO: log to file
            puts "skipping record with nil year_id => location_id: #{assign[:location_id]} production_id: #{assign[:production_id]} year_id: #{assign[:year_id]}"
          else
            work = ProductionCredits::Work.find_by_title(all_prods[assign[:production_id]])
            venue = venues[assign[:location_id].to_s]
            open_close_hash = years[assign[:year_id]]
            category = pick_category(work.title)

            # id, name, category, open_on, close_on, work_id, venue_id
            prod = create_production(assign[:assignment_id], work.title, category, open_close_hash['open_on'], open_close_hash['close_on'], work.attributes['id'], venue.attributes['id'])
            prods << prod
          end
        end
      end
      prods
    end

    def pick_category(title)
      # green show, osf standard, black signet, vining repertory, other
      if title.downcase.include?("green show")
        category = "Green Show"
      elsif title.downcase.include?("black signet")
        category = "Black Signet"
      elsif title.downcase.include?("vining repertory")
        category = "Vining Repertory"
      else title.downcase.include?("green show")
        category = "OSF Standard"
      end
      return category
    end

    def create_production(id, name, category, open_on, close_on, work_id, venue_id)
      sql_str = "insert into production_credits_productions (id, production_name, category, open_on, close_on, work_id, venue_id) values (#{id}, \"#{name}\", \"#{category}\", \"#{open_on}\", \"#{close_on}\", #{work_id}, #{venue_id})"
      begin
        ProductionCredits::Production.connection.execute(sql_str)
      rescue Exception => e
        puts e
      end
    end

    if ProductionCredits::Production.count != 0
      abort "shamelessly refusing to import as productions already exist"
    end

    venues = process_venues(venues_csv)
    #PP.pp(venues, $>, 40)

    works  = process_works(production_csv)
    #PP.pp(works, $>, 40)

    uniq_assign = uniq_assignments(assignment_csv)
    #PP.pp(uniq_assign, $>, 40)

    years = process_years(year_csv)
    #PP.pp(years, $>, 40)

    # reload production csv
    production_csv = CSV.open(args[:production], { :headers => true })
    productions = process_productions(production_csv, uniq_assign, works, venues, years)
    #PP.pp(productions, $>, 40)

    #prod_check = ProductionCredits::Production.all
    #PP.pp(prod_check, $>, 40)
    #puts "productions: #{productions.count}"
    #puts "prod check:  #{prod_check.count}"

    # TODO: Parse additional data exports

  end
end

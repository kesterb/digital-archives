module ProductionCredits
  class Venue < ActiveRecord::Base
    has_and_belongs_to_many :productions
    validates_presence_of :name


    def self.find_by_name_or_alias(name)
      venue_name = name.scan(/\(([^\)]+)\)/)
      if venue_name.empty?
        venue_name = name
      else
        venue_name = venue_name.last.first
      end
      ProductionCredits::Venue.where(name: venue_name).first
    end
  end
end

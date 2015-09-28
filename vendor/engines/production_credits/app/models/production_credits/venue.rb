module ProductionCredits
  class Venue < ActiveRecord::Base
    validates_presence_of :name

    belongs_to :canonical_venue, class_name: Venue
    has_and_belongs_to_many :productions

    def full_name
      canonical_venue ? "#{name} (#{canonical_venue.name})" : name
    end
  end
end

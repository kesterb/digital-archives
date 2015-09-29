module ProductionCredits
  class Venue < ActiveRecord::Base
    validates_presence_of :name

    belongs_to :canonical_venue, class_name: Venue
    has_and_belongs_to_many :productions

    def full_name
      canonical_name ? "#{name} (#{canonical_name})" : name
    end

    def all_names
      [name, canonical_name].compact
    end

    def canonical_name
      canonical_venue.try(:name)
    end
  end
end

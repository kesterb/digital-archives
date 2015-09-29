module ProductionCredits
  class Venue < ActiveRecord::Base
    include VenueAdmin

    scope :canonical, -> { where(canonical_venue_id: nil) }

    validates_presence_of :name
    validate :canonical_venue_cannot_be_an_alias,
             :alias_cannot_have_aliases

    belongs_to :canonical_venue, class_name: Venue, inverse_of: :aliases
    has_many :aliases,
             class_name: Venue,
             dependent: :nullify,
             foreign_key: :canonical_venue_id,
             inverse_of: :canonical_venue
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

    def canonical?
      canonical_venue_id.nil?
    end

    def alias?
      !canonical?
    end

    private

    def canonical_venue_cannot_be_an_alias
      if canonical_venue && canonical_venue.alias?
        errors.add(:canonical_venue, "cannot be an alias of another venue")
      end
    end

    def alias_cannot_have_aliases
      if alias? && aliases.any?
        errors.add(:base, "A venue with aliases of its own cannot be an alias")
      end
    end
  end
end

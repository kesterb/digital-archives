class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile

  def self.property(name, multiple:, &block)
    predicate = ::RDF::URI("http://docs.osfashland.org/terms/#{name}")
    super(name, predicate: predicate, multiple: multiple, &block)
  end

  property :production_ids, multiple: true

  property :production_names, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :venue_ids, multiple: true

  property :venue_names, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :work_id, multiple: false

  property :work_name, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :highlighted, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :year_created, multiple: false do |index|
    index.type :integer
    index.as :stored_sortable, :facetable
  end

  before_save :set_calculated_fields

  def discoverable?
    discover_groups.include?("public")
  end

  private

  def set_calculated_fields
    self.production_names = productions.map(&:production_name).compact
    self.venue_names = venues.map(&:name).compact
    self.work_name = work.try(:title)
    self.year_created = creation_year
  end

  def work
    ProductionCredits::Work.find(work_id) if work_id.present?
  end

  def productions
    production_ids ? ProductionCredits::Production.find(production_ids) : []
  end

  def venues
    if (venue_ids || []).any?
      ProductionCredits::Venue.find(venue_ids).compact
    elsif productions.any?
      productions.map(&:venue)
    else
      []
    end
  end

  def creation_year
    first_date = date_created.try(:first)
    first_date && Date.parse(first_date).year
  rescue ArgumentError
    nil
  end
end

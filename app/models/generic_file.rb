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

  property :work_ids, multiple: true

  property :work_names, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :curated, multiple: false do |index|
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
    UpdatesProductionCredits.update(self)
    self.year_created = creation_year
  end

  def creation_year
    first_date = date_created.try(:first)
    first_date && Date.parse(first_date).year
  rescue ArgumentError
    nil
  end
end

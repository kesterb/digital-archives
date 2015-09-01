class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile

  property :production_id, predicate: ::RDF::URI('http://docs.osfashland.org/terms/production_id'), multiple: false

  property :production_name, predicate: ::RDF::URI('http://docs.osfashland.org/terms/production_name'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :venue_id, predicate: ::RDF::URI('http://docs.osfashland.org/terms/venue_id'), multiple: false

  property :venue_name, predicate: ::RDF::URI('http://docs.osfashland.org/terms/venue_name'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :work_id, predicate: ::RDF::URI('http://docs.osfashland.org/terms/work_id'), multiple: false

  property :work_name, predicate: ::RDF::URI('http://docs.osfashland.org/terms/work_name'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :highlighted, predicate: ::RDF::URI('http://docs.osfashland.org/terms/highlighted'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :year_created, predicate: ::RDF::URI('http://docs/osfashland.org/terms/year_created'), multiple: false do |index|
    index.type :integer
    index.as :stored_sortable, :facetable
  end

  before_save :set_calculated_fields

  private

  def set_calculated_fields
    self.production_name = production.production_name if production
    self.venue_name = venue.name if venue
    self.work_name = work.title if work
    self.year_created = creation_year if creation_year
  end

  def work
    ProductionCredits::Work.find(work_id) if work_id
  end

  def production
    ProductionCredits::Production.find(production_id) if production_id
  end

  def venue
    if venue_id
      venue = ProductionCredits::Venue.find(venue_id)
    elsif production
      venue = production.venue
    end
  end

  def creation_year
    first_date = date_created.try(:first)
    first_date && Date.parse(first_date).year
  rescue ArgumentError
    nil
  end
end

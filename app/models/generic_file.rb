class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile

  property :production_name, predicate: ::RDF::URI('http://docs.osfashland.org/terms/production_name'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :venue_name, predicate: ::RDF::URI('http://docs.osfashland.org/terms/venue_name'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :work_name, predicate: ::RDF::URI('http://docs.osfashland.org/terms/work_name'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :highlighted, predicate: ::RDF::URI('http://docs.osfashland.org/terms/highlighted'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
end

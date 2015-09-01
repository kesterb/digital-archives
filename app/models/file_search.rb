require "solrizer"

class FileSearch
  def initialize(params, catalog_query:, file_query: GenericFile)
    @params = params
    @catalog_query = catalog_query
    @file_query = file_query
  end

  def search_term
    params[:q]
  end

  def work_name
    params[:work]
  end

  def venue_names
    params.fetch(:venues) { [] }
  end

  def self.year_range_limit
    1935..Date.today.year
  end

  def year_range_limit
    self.class.year_range_limit
  end

  def year_range
    raw = params.fetch(:years) { "" }
    from, to = raw.split(";").map(&method(:Integer))
    return year_range_limit unless from && to
    from..to
  rescue ArgumentError
    year_range_limit
  end

  def results
    SearchResults.new(files)
  end

  def files
    params.empty? ? highlighted_files : filtered_files
  end

  private

  attr_reader :params, :catalog_query, :file_query

  def highlighted_files
    file_query.where(highlighted: "1")
  end

  def filtered_files
    query = {}
    query[:q] = search_term if search_term
    query[:f] = filters unless filters.empty?

    (response, documents) = catalog_query.search_results(query, catalog_query.search_params_logic)
    files = file_query.find(documents.map(&:id))
  end

  def filters
    {}
      .merge(work_filter)
      .merge(venue_filter)
      .merge(year_filter)
  end

  def work_filter
    return {} unless work_name
    { Solrizer.solr_name("work_name") => work_name }
  end

  def venue_filter
    # TODO: Handle venue "Other"
    return {} if venue_names.empty?
    { Solrizer.solr_name("venue_name") => venue_names }
  end

  def year_filter
    return {} if year_range == year_range_limit
    { Solrizer.solr_name("year_created", :stored_sortable, type: :integer) => [year_range] }
  end
end

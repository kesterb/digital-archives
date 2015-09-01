require "solrizer"

class FileSearch
  def initialize(params, catalog_query:, file_query: GenericFile)
    @params = params
    @catalog_query = catalog_query
    @file_query = file_query
  end

  def self.all_years
    1935..Date.today.year
  end

  def all_works
    @all_works ||= ProductionCredits::Work.order(:title)
  end

  def all_venues
    @all_venues ||= hardcoded_venues
  end

  def all_venue_names
    all_venues.map(&:name)
  end

  def all_record_types
    @all_record_types ||= RECORD_TYPES
  end

  def all_years
    self.class.all_years
  end

  def search_term
    params[:q]
  end

  def work_name
    params[:work]
  end

  def venue_names
    params.fetch(:venues) { all_venue_names }
  end

  def record_types
    params.fetch(:record_types) { all_record_types }
  end

  def show_articles?
    record_types.include?("articles")
  end

  def show_images?
    record_types.include?("images")
  end

  def show_audios?
    record_types.include?("audios")
  end

  def show_videos?
    record_types.include?("videos")
  end

  def year_range
    raw = params.fetch(:years) { "" }
    from, to = raw.split(";").map(&method(:Integer))
    return all_years unless from && to
    from..to
  rescue ArgumentError
    all_years
  end

  def results
    SearchResults.new(files)
  end

  def files
    params.empty? ? highlighted_files : filtered_files
  end

  private

  VENUES = ["Elizabethan", "Angus Bowmer", "Thomas", "The Green Show"]
  RECORD_TYPES = %w[images videos audios articles]

  attr_reader :params, :catalog_query, :file_query

  def hardcoded_venues
    VENUES.map { |name| ProductionCredits::Venue.find_by(name: name) }.compact.tap do |venues|
      venues << ProductionCredits::Venue.new(name: "Other")
    end
  end

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
    return {} if venue_names.empty? || venue_names == all_venue_names
    { Solrizer.solr_name("venue_name") => venue_names }
  end

  def year_filter
    return {} if year_range == all_years
    { Solrizer.solr_name("year_created", :stored_sortable, type: :integer) => [year_range] }
  end
end

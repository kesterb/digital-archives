class SearchesController < CatalogController
  skip_before_action :authenticate_user!

  layout 'client'

  def index
    @works = ProductionCredits::Work.order(:title)
    @venues = hardcoded_venues
    @search = FileSearch.new(params, catalog_query: self)
    @results = @search.results
    # page = params[:page] || 1
    # per_page = params[:per_page] || 10
    # resource_type = params[:t].singularize.capitalize
    #
  end

  private

  VENUES = ["Elizabethan", "Angus Bowmer", "Thomas", "The Green Show"]

  def hardcoded_venues
    VENUES.map { |name| ProductionCredits::Venue.find_by(name: name) }.compact.tap do |venues|
      venues << ProductionCredits::Venue.new(name: "Other")
    end
  end

  # def do_search(query, filters, resource_type, page, per_page)
  #   facets = {desc_metadata__resource_type_sim: resource_type}
  #   facets.merge!(filters_to_query_values(filters)) unless !filters || filters.empty?
  #   q_params = {q: query, f: facets, page: page, per_page: per_page }
  # end
end

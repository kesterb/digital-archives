class SearchesController < CatalogController
  skip_before_action :authenticate_user!

  layout 'client'

  def index
    @search = FileSearch.new(params, catalog_query: self)
    @results = @search.results
    # page = params[:page] || 1
    # per_page = params[:per_page] || 10
    # resource_type = params[:t].singularize.capitalize
    #
  end

  private

  # def do_search(query, filters, resource_type, page, per_page)
  #   facets = {desc_metadata__resource_type_sim: resource_type}
  #   facets.merge!(filters_to_query_values(filters)) unless !filters || filters.empty?
  #   q_params = {q: query, f: facets, page: page, per_page: per_page }
  # end
end

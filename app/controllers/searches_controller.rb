class SearchesController < CatalogController
  skip_before_action :authenticate_user!

  layout 'client'

  def index
    @search = FileSearch.new(params, catalog_query: self)
    @articles = FileSearch.new(params.merge(:resource_types => ['Article']), catalog_query: self).articles
    @audios = FileSearch.new(params.merge(:resource_types => ['Audio']), catalog_query: self).audios
    @images = FileSearch.new(params.merge(:resource_types => ['Image']), catalog_query: self).images
    @videos = FileSearch.new(params.merge(:resource_types => ['Video']), catalog_query: self).videos


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

class SearchesController < CatalogController
  skip_before_action :authenticate_user!

  layout 'client'

  def index
    @works = ProductionCredits::Work.order(:title)
    @search = FileSearch.new(params, catalog_query: self)
    @results = @search.results

    # filter values
    # &filters%5Byear%5D=2014
    # year:2014

    # &filters%5Byears%5D%5B%5D=2009&filters%5Byears%5D%5B%5D=2014
    # years:[2000,2014]

    # @filters = params[:filters] || {}
    #
    # page = params[:page] || 1
    # per_page = params[:per_page] || 10
    # resource_type = params[:t].singularize.capitalize
    #
  end

  # def do_search(query, filters, resource_type, page, per_page)
  #   facets = {desc_metadata__resource_type_sim: resource_type}
  #   facets.merge!(filters_to_query_values(filters)) unless !filters || filters.empty?
  #   q_params = {q: query, f: facets, page: page, per_page: per_page }
  # end
  #
  # def filters_to_query_values(filters)
  #   query_values = filters.map do |filter, value|
  #     next if value.blank?
  #     case filter
  #       when 'years'
  #         # {asset_create_year_isi: [(1000...3000)]}
  #         {asset_create_year_isi: [value.map(&:to_i).inject{|s,e| s...e }]} # maps array with start and end to a range
  #       when 'year'
  #         # &filters%5Byear%5D=2014
  #         {asset_create_year_isi: value}
  #       when 'venues'
  #         unless value == ["Other"]
  #           {venue_name_sim: value}
  #         else
  #           {:'!venue_name_sim' => ["Elizabethan", "Thomas", "Angus Bowmer", "Green Show"]}
  #         end
  #       when 'work'
  #         {work_id_sim: value}
  #       else {}
  #     end
  #   end
  #
  #   query_values.reduce({}, :update) #reduces array of hashes to single hash
  # end
end

class SearchesController < CatalogController
  skip_before_action :authenticate_user!

  layout 'client'

  def index
    if params.has_key?(:q)
      query = { q: params[:q] }
      (response, documents) = search_results(query, search_params_logic)
      @files = GenericFile.find(documents.map(&:id)).group_by { |item| item.resource_type.first }
    else
      @files = GenericFile.where(highlighted: "1").group_by { |item| item.resource_type.first }
    end

    # @query = params[:q]
    # @query = 'featured'

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
    # unless @query == "featured" && @filters.empty?
    #   response = do_search(@query, @filters, resource_type, page, per_page)
    # else
    #
    #   response = build_response(featured(resource_type).collect(&:generic_file_solr_document))
    # end

    # render json: {'type' => params[:t], 'data' => response, 'filters' => @filters, 'query' => @query }
  end

#
# class SearchResultsController < CatalogController
#   layout "osf-client/application"
#   skip_before_action :verify_authenticity_token
#   skip_before_filter :authenticate_user!

    # headers['Access-Control-Allow-Origin'] = '*'



  # private
  #
  # def featured(resource_type)
  #   featured_list = FeaturedWorkList.new
  #   document_list = featured_list.featured_works
  #   document_list.to_a.delete_if{|f| f.generic_file_solr_document.resource_type[0] != resource_type}
  # end
  #
  # def do_search(query, filters, resource_type, page, per_page)
  #   facets = {desc_metadata__resource_type_sim: resource_type}
  #   facets.merge!(filters_to_query_values(filters)) unless !filters || filters.empty?
  #   q_params = {q: query, f: facets, page: page, per_page: per_page }
  #
  #   (res, res_document_list) = get_search_results(q_params)
  #   response = build_response(res.docs)
  #   response.merge({
  #     current_page: page,
  #     items_per_page: per_page,
  #     total_items: res.response['numFound']
  #   })
  # end
  #
  # def build_response(document_list)
  #   data = document_list.map { |d|
  #     file = GenericFile.find(d[:id])
  #
  #     # TODO: Update urls to use GenericFile properties.
  #     {
  #
  #       'id'            => d[:id][6..-1],
  #
  #       'visibility'    => file.visibility,
  #       'url'           => sufia.download_path(file),
  #       'thumbnail_url' => sufia.download_path(file, datastream_id: 'thumbnail'),
  #
  #       'webm_url'      => sufia.download_path(file, datastream_id: 'webm'),
  #       'mp4_url'       => sufia.download_path(file, datastream_id: 'mp4'),
  #
  #       'metadata' => file.public_metadata
  #     }
  #   }
  #
  #   return {data: data}
  # end
  #
  # # overidden from gems/blacklight-5.5.4/lib/blacklight/request_builders.rb
  # def add_facet_fq_to_solr(solr_parameters, user_params)
  #   # convert a String value into an Array
  #   if solr_parameters[:fq].is_a? String
  #     solr_parameters[:fq] = [solr_parameters[:fq]]
  #   end
  #
  #   # :fq, map from :f.
  #   if ( user_params[:f])
  #     f_request_params = user_params[:f]
  #
  #     f_request_params.each_pair do |facet_field, value_list|
  #       next if value_list.blank? # skip empty strings
  #       if facet_field == :asset_create_year_isi
  #         value_list.each do |value|
  #           solr_parameters.append_filter_query facet_value_to_fq_string(facet_field, value)
  #         end
  #
  #       elsif !value_list.is_a?(Array)
  #         solr_parameters.append_filter_query facet_value_to_fq_string(facet_field, value_list)
  #
  #       else
  #         query_join = (facet_field[0,1] == "!" ? " AND " : " OR ")
  #         query = value_list.map do |value|
  #           next if value.blank? # skip empty strings
  #           "#{facet_field}:\"#{value}\""
  #         end
  #
  #         solr_parameters.append_filter_query(query.join(query_join))
  #       end
  #     end
  #   end
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

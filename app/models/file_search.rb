class FileSearch
  def initialize(params, catalog_query:, file_query: GenericFile)
    @params = params
    @catalog_query = catalog_query
    @file_query = file_query
  end

  def results
    params.empty? ? highlighted_files : filtered_files
  end

  private

  attr_reader :params, :catalog_query, :file_query

  def highlighted_files
    file_query.where(highlighted: "1")
  end

  def filtered_files
    query = {
      q: params[:q]
    }
    #     f: {
    #       Solrizer.solr_name('work_id') => params["work_id"].to_s
    #     }

    (response, documents) = catalog_query.search_results(query, catalog_query.search_params_logic)
    files = file_query.find(documents.map(&:id))
  end
end

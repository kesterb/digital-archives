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
    query[:f] = filters if filters

    (response, documents) = catalog_query.search_results(query, catalog_query.search_params_logic)
    files = file_query.find(documents.map(&:id))
  end

  def filters
    work_name ? { Solrizer.solr_name("work_name") => work_name } : nil
  end
end

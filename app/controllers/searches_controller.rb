class SearchesController < CatalogController
  skip_before_action :authenticate_user!

  layout 'client'

  def index
    @search = FileSearch.new(params, catalog_query: self)
    get_audios
    get_videos
    get_images
    get_articles
    # page = params[:page] || 1
    # per_page = params[:per_page] || 10
    # resource_type = params[:t].singularize.capitalize
    #
  end

  def videos
    get_videos
    render layout: false
  end

  def images
    get_images
    render layout: false
  end

  def articles
    get_articles
    render layout: false
  end

  def audios
    get_audios
    render layout: false
  end

  private

  def get_audios
    @audios_search = FileSearch.new(params.merge(:resource_types => ['Audio']), catalog_query: self)
    @audios = @audios_search.files
  end

  def get_videos
    @videos_search = FileSearch.new(params.merge(:resource_types => ['Video']), catalog_query: self)
    @videos = @videos_search.files
  end

  def get_articles
    @articles_search = FileSearch.new(params.merge(:resource_types => ['Article']), catalog_query: self)
    @articles = @articles_search.files
  end

  def get_images
    @images_search = FileSearch.new(params.merge(:resource_types => ['Image']), catalog_query: self)
    @images = @images_search.files
  end
end

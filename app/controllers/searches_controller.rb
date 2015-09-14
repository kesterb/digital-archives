class SearchesController < CatalogController
  skip_before_action :authenticate_user!

  layout 'client'

  def index
    @search = FileSearch.new(params, resource_type: nil, catalog_query: self)
    get_audios
    get_videos
    get_images
    get_articles
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
    audios_search = FileSearch.new(params, resource_type: :audio, catalog_query: self)
    @audios = audios_search.result
  end

  def get_videos
    videos_search = FileSearch.new(params, resource_type: :video, catalog_query: self)
    @videos = videos_search.result
  end

  def get_articles
    articles_search = FileSearch.new(params, resource_type: :article, catalog_query: self)
    @articles = articles_search.result
  end

  def get_images
    images_search = FileSearch.new(params, resource_type: :image, catalog_query: self)
    @images = images_search.result
  end
end

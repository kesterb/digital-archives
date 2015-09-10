class SearchResults
  def initialize(response, files)
    @response = response
    @items = files
  end

  def files
    @items
  end

  def show_more?
    total_pages > current_page
  end

  def has_items?
    total_items > 0
  end

  def current_page
    response.current_page
  end

  def next_page
    response.next_page
  end

  def show_more?
    total_pages > current_page
  end

  def has_items?
    total_items > 0
  end

  def total_items
    response.response["numFound"]
  end

  def total_pages
    response.total_pages
  end
  #
  # def videos
  #   items.fetch("Video") { [] }
  # end
  #
  # def video_count
  #   videos.size
  # end
  #
  # def has_videos?
  #   video_count > 0
  # end
  #
  # def articles
  #   items.fetch("Article") { [] }
  # end
  #
  # def article_count
  #   articles.size
  # end
  #
  # def has_articles?
  #   article_count > 0
  # end
  #
  # def audios
  #   items.fetch("Audio") { [] }
  # end
  #
  # def audio_count
  #   audios.size
  # end
  #
  # def has_audios?
  #   audio_count > 0
  # end
  #
  # def images
  #   items.fetch("Image") { [] }
  # end
  #
  # def image_count
  #   images.size
  # end
  #
  # def has_images?
  #   image_count > 0
  # end

  private

  attr_reader :response, :items
end

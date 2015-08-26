class SearchResults
  def initialize(files)
    @items = files.group_by { |item| item.resource_type.first }
  end

  def videos
    items.fetch("Video") { [] }
  end

  def video_count
    videos.size
  end

  def has_videos?
    video_count > 0
  end

  def articles
    items.fetch("Article") { [] }
  end

  def article_count
    articles.size
  end

  def has_articles?
    article_count > 0
  end

  def audios
    items.fetch("Audio") { [] }
  end

  def audio_count
    audios.size
  end

  def has_audios?
    audio_count > 0
  end

  def images
    items.fetch("Image") { [] }
  end

  def image_count
    images.size
  end

  def has_images?
    image_count > 0
  end
  
  private

  attr_reader :items
end

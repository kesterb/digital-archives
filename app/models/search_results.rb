class SearchResults
  def initialize(response, files)
    @response = response
    @items = files
  end

  def files
    @items
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

  def self.empty
    EmptySearchResults.new
  end

  private

  attr_reader :response, :items
end

class EmptySearchResults
  def has_items?
    false
  end

  def total_items
    0
  end

  def files
    []
  end

  def show_more?
    false
  end
end

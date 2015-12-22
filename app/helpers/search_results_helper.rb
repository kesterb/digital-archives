module SearchResultsHelper
  def formatted_creation_date(file)
    date = file.date_created.first
    if date
      date.to_date.to_s(:mdy)
    else
      file.year_created
    end
  end

  def unreadable?(file)
    can?(:discover, file) && cannot?(:read, file)
  end

  def image_orientation(image)
    ratio = image.height.first.to_f / image.width.first.to_f

    if ratio > 1.1
      :portrait
    elsif ratio < 0.9
      :landscape
    else
      :square
    end
  end

  COLUMNS = {
    portrait: 4,
    square: 6,
    landscape: 8
  }

  def column_style(image)
    columns = COLUMNS.fetch(image_orientation(image)) { 6 }
    "c-#{columns}"
  end
end

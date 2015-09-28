module GenericFileProductionHelper
  def productions_for_select
    productions = ProductionCredits::Production.order(:production_name)
    productions.map { |p| { "#{p.production_name} - #{p.open_on.year}" => p.id } }.reduce({}, :update)
  end

  def works_for_select
    works = ProductionCredits::Work.order(:title)
    works.map { |w| { w.title => w.id } }.reduce({}, :update)
  end

  def venues_for_select
    venues = ProductionCredits::Venue.order(:name)
    venues.map { |v| { v.name => v.id } }.reduce({}, :update)
  end

  def event_types_for_select
    types = ProductionCredits::EventType.order(:name)
    types.map { |type| { type.name => type.id } }.reduce({}, :update)
  end

  def formatted_creation_date(file)
    date = file.date_created.first
    return "" unless date

    date.to_date.to_s(:mdy)
  end
end

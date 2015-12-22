module GenericFileProductionHelper
  def productions_for_select
    productions = ProductionCredits::Production.order(:production_name, open_on: :desc)
    productions.map { |p| { p.name => p.id } }.reduce({}, :update)
  end

  def works_for_select
    works = ProductionCredits::Work.order(:title)
    works.map { |w| { w.title => w.id } }.reduce({}, :update)
  end

  def venues_for_select
    venues = ProductionCredits::Venue.order(:name)
    venues.map { |v| { v.full_name => v.id } }.reduce({}, :update)
  end

  def event_types_for_select
    types = ProductionCredits::EventType.order(:name)
    types.map { |type| { type.name => type.id } }.reduce({}, :update)
  end
end

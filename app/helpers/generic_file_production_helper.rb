module GenericFileProductionHelper
  # def production_names
  #   ProductionCredits::Production.order(:production_name).pluck(:production_name)
  # end

  def productions_for_select
    productions = ProductionCredits::Production.order(:production_name)
    productions.collect{|p| {"#{p.production_name} - #{p.open_on.year}" => p.id}}.reduce({}, :update)
  end

  def works_for_select
    works = ProductionCredits::Work.order(:title)
    works.collect{|w| {"#{w.title}" => w.id}}.reduce({}, :update)
  end

  def venues_for_select
    venues = ProductionCredits::Venue.order(:name)
    venues.collect{|v| {"#{v.name}" => v.id}}.reduce({}, :update)
  end

  # def venue_names
  #   names = ProductionCredits::Venue.pluck(:name)
  #   productions = ProductionCredits::Production.where("venue_alias != ''")
  #   venue_aliases = productions.map{|production| "#{production.venue_alias} (#{production.venue.name})"}
  #   names.concat venue_aliases
  #   names.compact.sort
  # end
end

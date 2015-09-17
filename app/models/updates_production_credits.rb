class UpdatesProductionCredits
  include ProductionCredits

  def self.update(generic_file)
    new(generic_file).update
  end

  def initialize(generic_file)
    @generic_file = generic_file
  end

  def update
    update_productions
    update_venues
    update_works
  end

  private

  attr_reader :generic_file

  def update_productions
    generic_file.production_names = productions.map(&:production_name).compact
  end

  def update_venues
    generic_file.venue_ids = venues.map(&:id).compact
    generic_file.venue_names = venues.map(&:name).compact
  end

  def update_works
    generic_file.work_ids = works.map(&:id).compact
    generic_file.work_names = works.map(&:title).compact
  end

  def productions
    @productions ||= begin
      ids = generic_file.production_ids
      ids ? Production.find(ids).compact : []
    end
  end

  def venues
    @venues ||= begin
      ids = generic_file.venue_ids || []
      (ids.any? ? Venue.find(ids) : productions.map(&:venue)).compact
    end
  end

  def works
    @works ||= begin
      ids = generic_file.work_ids || []
      (ids.any? ? Work.find(ids) : productions.map(&:work)).compact
    end
  end
end

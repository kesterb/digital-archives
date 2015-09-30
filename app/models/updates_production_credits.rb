class UpdatesProductionCredits
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
    update_event_type
  end

  private

  attr_reader :generic_file

  def update_productions
    generic_file.production_names = productions.map(&:production_name).compact
  end

  def update_venues
    generic_file.venue_names = venues.flat_map(&:all_names).compact
    generic_file.venue_full_names = venues.map(&:full_name).compact
  end

  def update_works
    generic_file.work_ids = works.map(&:id).compact.map(&:to_s)
    generic_file.work_names = works.map(&:title).compact
  end

  def update_event_type
    generic_file.event_type_name = event_type.try(:name)
  end

  def productions
    @productions ||= begin
      ids = generic_file.production_ids
      ids ? ProductionCredits::Production.find(ids).compact : []
    end
  end

  def venues
    @venues ||= begin
      ids = generic_file.venue_ids
      ids ? ProductionCredits::Venue.find(ids).compact : []
    end
  end

  def works
    @works ||= begin
      ids = generic_file.work_ids || []
      (ids.any? ? ProductionCredits::Work.find(ids) : productions.map(&:work)).compact
    end
  end

  def event_type
    id = generic_file.event_type_id
    ProductionCredits::EventType.find(id) unless id.blank?
  end
end

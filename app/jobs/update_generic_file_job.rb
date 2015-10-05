class UpdateGenericFileJob
  def self.for_event_type(event_type)
    new(event_type, :event_type_id)
  end

  def self.for_production(production)
    new(production, :production_ids)
  end

  def self.for_venue(venue)
    new(venue, :venue_ids)
  end

  def self.for_work(work)
    new(work, :work_ids)
  end

  private_class_method :new

  def initialize(record, search_key)
    @id = record.id
    @search_key = search_key
  end

  def queue_name
    :generic_file_update
  end

  def run
    GenericFile.where(search_key => id.to_s).each(&:save!)
  end

  private

  attr_reader :id, :search_key
end

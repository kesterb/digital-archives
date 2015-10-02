class UpdateGenericFileForEventTypeJob
  def initialize(event_type)
    @id = event_type.id
  end

  def queue_name
    :generic_file_update
  end

  def run
    GenericFile.where(event_type_id: id.to_s).each(&:save!)
  end

  private

  attr_reader :id
end

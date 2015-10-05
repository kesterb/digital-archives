class UpdateGenericFileForEventTypeJob < UpdateGenericFileJob
  def run
    GenericFile.where(event_type_id: id.to_s).each(&:save!)
  end
end

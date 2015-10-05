class UpdateGenericFileForVenueJob < UpdateGenericFileJob
  def run
    GenericFile.where(venue_ids: id.to_s).each(&:save!)
  end
end

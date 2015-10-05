class UpdateGenericFileForProductionJob < UpdateGenericFileJob
  def run
    GenericFile.where(production_ids: id.to_s).each(&:save!)
  end
end

class UpdateGenericFileForWorkJob < UpdateGenericFileJob
  def run
    GenericFile.where(work_ids: id.to_s).each(&:save!)
  end
end

class UpdateGenericFileForWorkJob
  def initialize(work)
    @id = work.id
  end

  def queue_name
    :generic_file_update
  end

  def run
    GenericFile.where(work_ids: id.to_s).each(&:save!)
  end

  private

  attr_reader :id
end

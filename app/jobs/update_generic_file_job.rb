class UpdateGenericFileJob
  def initialize(record)
    @id = record.id
  end

  def queue_name
    :generic_file_update
  end

  def run
    fail NotImplementedError, "Subclasses must implement :run"
  end

  private

  attr_reader :id
end

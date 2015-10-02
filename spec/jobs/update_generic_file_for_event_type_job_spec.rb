require "rails_helper"

RSpec.describe UpdateGenericFileForEventTypeJob do
  subject(:update) { described_class.new(event_type) }
  let(:generic_file) { instance_spy(GenericFile) }
  let(:event_type) { instance_double(ProductionCredits::EventType, id: 42) }

  before do
    allow(GenericFile).to receive(:where).with(event_type_id: event_type.id.to_s) { [generic_file] }
    update.run
  end

  it "resaves affected files" do
    expect(generic_file).to have_received(:save!)
  end
end

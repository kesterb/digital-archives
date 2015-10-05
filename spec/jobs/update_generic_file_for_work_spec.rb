require "rails_helper"

RSpec.describe UpdateGenericFileForWorkJob do
  subject(:update) { described_class.new(work) }
  let(:generic_file) { instance_spy(GenericFile) }
  let(:work) { instance_double(ProductionCredits::Work, id: 42) }

  before do
    allow(GenericFile).to receive(:where).with(work_ids: work.id.to_s) { [generic_file] }
    update.run
  end

  it "resaves affected files" do
    expect(generic_file).to have_received(:save!)
  end
end

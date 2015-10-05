require "rails_helper"

RSpec.describe UpdateGenericFileForProductionJob do
  subject(:update) { described_class.new(production) }
  let(:generic_file) { instance_spy(GenericFile) }
  let(:production) { instance_double(ProductionCredits::Production, id: 42) }

  before do
    allow(GenericFile).to receive(:where).with(production_ids: production.id.to_s) { [generic_file] }
    update.run
  end

  it "resaves affected files" do
    expect(generic_file).to have_received(:save!)
  end
end

require "rails_helper"

RSpec.describe UpdateGenericFileForVenueJob do
  subject(:update) { described_class.new(venue) }
  let(:generic_file) { instance_spy(GenericFile) }
  let(:venue) { instance_double(ProductionCredits::Venue, id: 42) }

  before do
    allow(GenericFile).to receive(:where).with(venue_ids: venue.id.to_s) { [generic_file] }
    update.run
  end

  it "resaves affected files" do
    expect(generic_file).to have_received(:save!)
  end
end

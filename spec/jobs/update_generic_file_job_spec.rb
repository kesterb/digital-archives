require "rails_helper"

RSpec.describe UpdateGenericFileJob do
  let(:generic_file) { instance_spy(GenericFile) }

  context "for an event type" do
    subject(:update) { described_class.for_event_type(event_type) }
    let(:event_type) { instance_double(ProductionCredits::EventType, id: 42) }

    before do
      allow(GenericFile).to receive(:where).with(event_type_id: event_type.id.to_s) { [generic_file] }
      update.run
    end

    it "resaves affected files" do
      expect(generic_file).to have_received(:save!)
    end
  end

  context "for a production" do
    subject(:update) { described_class.for_production(production) }
    let(:production) { instance_double(ProductionCredits::Production, id: 42) }

    before do
      allow(GenericFile).to receive(:where).with(production_ids: production.id.to_s) { [generic_file] }
      update.run
    end

    it "resaves affected files" do
      expect(generic_file).to have_received(:save!)
    end
  end

  context "for a venue" do
    subject(:update) { described_class.for_venue(venue) }
    let(:venue) { instance_double(ProductionCredits::Venue, id: 42) }

    before do
      allow(GenericFile).to receive(:where).with(venue_ids: venue.id.to_s) { [generic_file] }
      update.run
    end

    it "resaves affected files" do
      expect(generic_file).to have_received(:save!)
    end
  end

  context "for a work" do
    subject(:update) { described_class.for_work(work) }
    let(:work) { instance_double(ProductionCredits::Work, id: 42) }

    before do
      allow(GenericFile).to receive(:where).with(work_ids: work.id.to_s) { [generic_file] }
      update.run
    end

    it "resaves affected files" do
      expect(generic_file).to have_received(:save!)
    end
  end
end

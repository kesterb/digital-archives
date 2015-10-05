require "rails_helper"

module Observers
  RSpec.describe VenueObserver do
    let(:queue) { Sufia.queue }

    before do
      allow(queue).to receive(:push)
    end

    context "when modifying a venue" do
      context "when editing the name" do
        let(:venue) { ProductionCredits::Venue.create!(name: "OLD") }

        before do
          venue.update_attributes(name: "NEW")
        end

        it "queues an update job" do
          expect(queue).to have_received(:push).with(UpdateGenericFileForVenueJob)
        end
      end
    end

    context "when creating a new venue" do
      before do
        ProductionCredits::Venue.create!(name: "NEW")
      end

      it "does not queue an update job" do
        expect(queue).not_to have_received(:push)
      end
    end
  end
end

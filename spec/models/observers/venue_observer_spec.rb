require "rails_helper"

module Observers
  RSpec.describe VenueObserver do
    let(:queue) { Sufia.queue }

    before do
      allow(queue).to receive(:push)
    end

    context "when modifying a venue" do
      let(:venue) { ProductionCredits::Venue.create!(name: "OLD") }

      context "when editing the name" do
        before do
          venue.update_attributes(name: "NEW")
        end

        it "queues an update job" do
          expect(queue).to have_received(:push).with(UpdateGenericFileJob)
        end
      end

      context "when editing the canonical_venue" do
        let(:canonical_venue) { ProductionCredits::Venue.create!(name: "Canonical") }

        before do
          venue.update_attributes(canonical_venue: canonical_venue)
        end

        it "queues an update job" do
          expect(queue).to have_received(:push).with(UpdateGenericFileJob)
        end
      end

      context "that has aliases" do
        before do
          2.times.each { |n| venue.aliases.create!(name: "Alias #{n}") }

          venue.update_attributes(name: "NEW")
        end

        it "queues separate update jobs for the venue and each of its aliases" do
          expect(queue).to have_received(:push).exactly(3).times
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

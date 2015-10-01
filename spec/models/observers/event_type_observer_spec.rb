require "rails_helper"

module Observers
  RSpec.describe EventTypeObserver do
    let(:queue) { Sufia.queue }

    before do
      allow(queue).to receive(:push)
    end

    context "when editing the name" do
      let(:event_type) { ProductionCredits::EventType.create!(name: "OLD") }

      before do
        event_type.update_attributes(name: "NEW")
      end

      it "queues an update job" do
        expect(queue).to have_received(:push).with(UpdateGenericFileForEventTypeJob)
      end
    end

    context "when creating a new event type" do
      before do
        ProductionCredits::EventType.create!(name: "NEW")
      end

      it "does not queue an update job" do
        expect(queue).not_to have_received(:push)
      end
    end
  end
end

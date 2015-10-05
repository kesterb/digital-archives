require "rails_helper"

module Observers
  RSpec.describe WorkObserver do
    let(:queue) { Sufia.queue }

    before do
      allow(queue).to receive(:push)
    end

    context "when modifying a work" do
      let(:work) { ProductionCredits::Work.create!(title: "OLD") }

      context "when editing the title" do
        before do
          work.update_attributes(title: "NEW")
        end

        it "queues an update job" do
          expect(queue).to have_received(:push).with(UpdateGenericFileForWorkJob)
        end
      end

      context "when editing any other attribute" do
        before do
          work.update_attributes(author: "AUTHOR", description: "DESC")
        end

        it "does not queue an update job" do
          expect(queue).not_to have_received(:push)
        end
      end
    end

    context "when creating a new work" do
      before do
        ProductionCredits::Work.create!(title: "NEW")
      end

      it "does not queue an update job" do
        expect(queue).not_to have_received(:push)
      end
    end
  end
end

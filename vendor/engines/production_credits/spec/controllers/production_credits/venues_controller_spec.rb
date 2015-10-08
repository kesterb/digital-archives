require "spec_helper"

module ProductionCredits
  RSpec.describe VenuesController, type: :controller do
    routes { ProductionCredits::Engine.routes }

    describe "#index" do
      let(:ids) { %w[1 2 3] }
      let(:all_venues) { 5.times.map { |n| double(to_json: { name: "VENUE #{n}" }) } }

      before do
        allow(Venue).to receive(:for_production_ids).with(ids) { filtered_venues }
        allow(Venue).to receive(:all) { all_venues }

        get :index, params
      end

      context "when production ids are provided" do
        let(:params) { { production_ids: ids } }

        context "when filtered results are found" do
          let(:filtered_venues) { all_venues.first(2) }

          it "returns filtered venues" do
            expect(response.body).to eq filtered_venues.to_json
          end
        end

        context "when filtered results are not found" do
          let(:filtered_venues) { [] }

          it "returns all venues" do
            expect(response.body).to eq all_venues.to_json
          end
        end
      end

      context "when production ids are not provided" do
        let(:params) { {} }

        it "immediately retrieves all venues" do
          expect(Venue).not_to have_received(:for_production_ids)
          expect(response.body).to eq all_venues.to_json
        end
      end
    end
  end
end

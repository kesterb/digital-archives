require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:user) }
  let(:generic_file) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
    end
  end
  let(:production) do
    instance_double(ProductionCredits::Production,
                    id: 1,
                    production_name: "The Production",
                    work: nil)
  end
  let(:venue) { instance_double(ProductionCredits::Venue, id: 2, name: "The Venue") }
  let(:attributes) do
    {
      production_ids: [production.id],
      venue_ids: [venue.id]
    }
  end
  let(:reloaded) { generic_file.reload }

  before do
    allow(ProductionCredits::Production).to receive(:find)
      .with([production.id.to_s]) { [production] }
    allow(ProductionCredits::Production).to receive(:find).with([]) { [] }
    allow(ProductionCredits::Venue).to receive(:find).with([venue.id.to_s]) { [venue] }
    allow(ProductionCredits::Venue).to receive(:find).with([]) { [] }
    sign_in user
    post :update, id: generic_file, generic_file: attributes
  end

  it "persists the ids" do
    expect(reloaded.production_ids).to eq [production.id.to_s]
    expect(reloaded.venue_ids).to eq [venue.id.to_s]
  end

  it "finds and persists the names" do
    expect(reloaded.production_names).to eq [production.production_name]
    expect(reloaded.venue_names).to eq [venue.name]
  end
end

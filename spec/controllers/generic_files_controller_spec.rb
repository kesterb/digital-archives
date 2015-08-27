require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:user) }
  let(:generic_file) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
    end
  end
  let(:production) { instance_double(ProductionCredits::Production, production_name: "The Production") }
  let(:venue) { instance_double(ProductionCredits::Venue, name: 'The Venue') }
  let(:work) { instance_double(ProductionCredits::Work, title: 'The Work') }
  let(:production_id) { 1 }
  let(:venue_id) { 2 }
  let(:work_id) { 3 }
  let(:attributes) { { production_id: production_id, venue_id: venue_id, work_id: work_id } }
  let(:reloaded) { generic_file.reload }

  before do
    allow(ProductionCredits::Production).to receive(:find).with(production_id.to_s) { production }
    allow(ProductionCredits::Venue).to receive(:find).with(venue_id.to_s) { venue }
    allow(ProductionCredits::Work).to receive(:find).with(work_id.to_s) { work }
    sign_in user
    post :update, id: generic_file, generic_file: attributes
  end

  it "persists the ids" do
    expect(reloaded.production_id).to eq production_id.to_s
    expect(reloaded.venue_id).to eq venue_id.to_s
    expect(reloaded.work_id).to eq work_id.to_s
  end

  it "finds and persists the names" do
    expect(reloaded.production_name).to eq production.production_name
    expect(reloaded.venue_name).to eq venue.name
    expect(reloaded.work_name).to eq work.title
  end
end

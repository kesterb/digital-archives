require 'rails_helper'

describe GenericFilesController do
  Production = ProductionCredits::Production
  Venue = ProductionCredits::Venue
  Work = ProductionCredits::Work

  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:user) }
  let(:generic_file) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
    end
  end
  let(:production) do
    instance_double(Production, production_name: "The Production")
  end
  let(:venue) { instance_double(Venue, name: "The Venue") }
  let(:work) { instance_double(Work, title: "The Work") }
  let(:production_id) { 1 }
  let(:venue_id) { 2 }
  let(:work_id) { 3 }
  let(:attributes) do
    {
      production_ids: [production_id],
      venue_ids: [venue_id],
      work_id: work_id
    }
  end
  let(:reloaded) { generic_file.reload }

  before do
    allow(Production).to receive(:find)
      .with([production_id.to_s]) { [production] }
    allow(Production).to receive(:find).with([]) { [] }
    allow(Venue).to receive(:find).with([venue_id.to_s]) { [venue] }
    allow(Work).to receive(:find).with(work_id.to_s) { work }
    sign_in user
    post :update, id: generic_file, generic_file: attributes
  end

  it "persists the ids" do
    expect(reloaded.production_ids).to eq [production_id.to_s]
    expect(reloaded.venue_ids).to eq [venue_id.to_s]
    expect(reloaded.work_id).to eq work_id.to_s
  end

  it "finds and persists the names" do
    expect(reloaded.production_names).to eq [production.production_name]
    expect(reloaded.venue_names).to eq [venue.name]
    expect(reloaded.work_name).to eq work.title
  end
end

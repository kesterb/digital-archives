require 'rails_helper'

shared_examples "a persisted custom property" do |property_name|
  let(:attributes) { { property_name.to_sym => 'My Property' } }
  let(:generic_file) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
    end
  end

  before { post :update, id: generic_file, generic_file: attributes }

  subject do
    generic_file.reload.send(property_name)
  end

  it { is_expected.to eq "My Property" }
end

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:user) }
  before { sign_in user }

  describe "update" do
    it_behaves_like "a persisted custom property", "production_name"
    it_behaves_like "a persisted custom property", "venue_name"
    it_behaves_like "a persisted custom property", "work_name"
  end
end

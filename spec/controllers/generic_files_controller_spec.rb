require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:user) }
  before { sign_in user }

  describe "update" do
    let(:generic_file) do
      GenericFile.create do |gf|
        gf.apply_depositor_metadata(user)
      end
    end

    context "when adding a production name" do
      let(:attributes) { { production_name: 'My Production' } }
      before { post :update, id: generic_file, generic_file: attributes }
      subject do
        generic_file.reload.production_name
      end
      it { is_expected.to eq "My Production" }
    end

    context "when adding a venue name" do
      let(:attributes) { { venue_name: 'My Venue' } }
      before { post :update, id: generic_file, generic_file: attributes }
      subject do
        generic_file.reload.venue_name
      end
      it { is_expected.to eq "My Venue" }
    end

    context "when adding a work name" do
      let(:attributes) { { work_name: 'My Work' } }
      before { post :update, id: generic_file, generic_file: attributes }
      subject do
        generic_file.reload.work_name
      end
      it { is_expected.to eq "My Work" }
    end
  end
end

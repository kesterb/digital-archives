require 'rails_helper'

describe GenericFile do
  let(:file) do
    GenericFile.create do |f|
      f.apply_depositor_metadata "user"
    end
  end

  describe "has a production name property" do
    let(:production_name) { "My Production" }

    before do
      file.production_name = production_name
    end

    subject { file.production_name }

    it 'can access the property' do
      is_expected.to eql production_name
    end

    it 'indexes the values' do
      expect(file.to_solr[Solrizer.solr_name("production_name")]).to eq [production_name]
    end
  end

  describe "has a venue name property" do
    let(:venue_name) { "My Venue" }

    before do
      file.venue_name = venue_name
    end

    subject { file.venue_name }

    it 'can access the property' do
      is_expected.to eql venue_name
    end

    it 'indexes the values' do
      expect(file.to_solr[Solrizer.solr_name("venue_name")]).to eq [venue_name]
    end
  end

  describe "has a work name property" do
    let(:work_name) { "My Work" }

    before do
      file.work_name = work_name
    end

    subject { file.work_name }

    it 'can access the property' do
      is_expected.to eql work_name
    end

    it 'indexes the values' do
      expect(file.to_solr[Solrizer.solr_name("work_name")]).to eq [work_name]
    end
  end

end

require 'rails_helper'

shared_examples "a custom property" do |property_name|
  let(:property_value) { "My Property" }
  let(:file) do
    GenericFile.create do |f|
      f.apply_depositor_metadata "user"
    end
  end

  before do
    file.send("#{property_name}=", property_value)
  end

  subject { file.send(property_name) }

  it 'can access the property' do
    is_expected.to eql property_value
  end

  it 'indexes the values' do
    expect(file.to_solr[Solrizer.solr_name(property_name)]).to eq [property_value]
  end
end

describe GenericFile do
  it_behaves_like "a custom property", "production_name"
  it_behaves_like "a custom property", "venue_name"
  it_behaves_like "a custom property", "work_name"
  it_behaves_like "a custom property", "highlighted"
end

require "spec_helper"
require "models/file_search"

describe FileSearch do
  subject(:search) { described_class.new(params, catalog_query: catalog_query, file_query: file_query) }
  let(:logic) { double("Search Params Logic") }
  let(:catalog_query) { double("Catalog query", search_params_logic: logic) }
  let(:file_query) { double("File query") }
  let(:files) { [double("GenericFile1"), double("GenericFile2")] }

  context "with no params" do
    let(:params) { {} }

    before do
      allow(file_query).to receive(:where).with(highlighted: "1") { files }
    end

    it "returns highlighted files" do
      expect(search.files).to eq files
    end
  end

  describe "filtering" do
    let(:document_ids) { [42, 58] }
    let(:documents) { document_ids.map { |id| double("SolrDocument", id: id) } }

    before do
      allow(catalog_query).to receive(:search_results).with(expected_query, logic) { [double("Response"), documents] }
      allow(file_query).to receive(:find).with(document_ids) { files }
    end

    context "with a search term" do
      let(:params) { { q: "TERM" } }
      let(:expected_query) { { q: "TERM" } }

      it "returns found files" do
        expect(search.files).to eq files
      end
    end

    context "with a selected work" do
      let(:params) { { work: "WORK" } }
      let(:expected_query) { { f: { Solrizer.solr_name("work_name") => "WORK" } } }

      it "returns found files" do
        expect(search.files).to eq files
      end
    end
  end
end

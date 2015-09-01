require "spec_helper"
require "models/file_search"

describe FileSearch do
  # TODO: Write a custom matcher to check that the Solr query is what we want,
  # rather than checking the returned files over and over again.  The query is
  # what we're really interested in.
  #
  # We might have to test things the same way as we do now, but we can hide
  # the duplication in the matcher.

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

    describe "by venue" do
      context "with one venue selected" do
        let(:params) { { venues: %w[VENUE] } }
        let(:expected_query) { { f: { Solrizer.solr_name("venue_name") => %w[VENUE] } } }

        it "returns found files" do
          expect(search.files).to eq files
        end
      end

      context "with several venues selected" do
        let(:params) { { venues: %w[VENUE1 VENUE2] } }
        let(:expected_query) { { f: { Solrizer.solr_name("venue_name") => %w[VENUE1 VENUE2] } } }

        it "returns found files" do
          expect(search.files).to eq files
        end
      end
    end

    describe "by year range" do
      context "with a limited range" do
        let(:params) { { years: "1968;1991" } }
        let(:expected_query) { { f: { year_created_isi: [1968..1991] } } }

        it "returns found files" do
          expect(search.files).to eq files
        end
      end

      context "with the full date range" do
        let(:params) { { years: "#{default_range.begin};#{default_range.end}" } }
        let(:expected_query) { {} }
        let(:default_range) { described_class.year_range_limit }

        it "returns found files" do
          expect(search.files).to eq files
        end
      end
    end
  end

  describe "years parameter parsing" do
    let(:range) { search.year_range }
    let(:default_range) { described_class.year_range_limit }

    context "with no years parameter" do
      let(:params) { {} }

      specify { expect(range).to eq default_range }
    end

    context "with empty years parameter" do
      let(:params) { { years: "" } }

      specify { expect(range).to eq default_range }
    end

    context "with no separator" do
      let(:params) { { years: "1492" } }

      specify { expect(range).to eq default_range }
    end

    context "with non-integer values" do
      let(:params) { { years: "not;integer"} }

      specify { expect(range).to eq default_range }
    end

    context "with valid range" do
      let(:params) { { years: "1942;1968"} }

      specify { expect(range).to eq 1942..1968 }
    end
  end
end

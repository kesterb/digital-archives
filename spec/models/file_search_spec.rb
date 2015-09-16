require "rails_helper"

describe FileSearch do
  # TODO: Write a custom matcher to check that the Solr query is what we want,
  # rather than checking the returned files over and over again.  The query is
  # what we're really interested in.
  #
  # We might have to test things the same way as we do now, but we can hide
  # the duplication in the matcher.

  subject(:search) { described_class.new(params, resource_type: resource_type, catalog_query: catalog_query, file_query: file_query) }
  let(:logic) { double("Search Params Logic") }
  let(:resource_type) { nil }
  let(:catalog_query) { double("Catalog query", search_params_logic: logic) }
  let(:file_query) { double("File query") }
  let(:files) { [double("GenericFile1"), double("GenericFile2")] }
  let(:response) do
    double("Response",
            total_pages: 2,
            current_page: 1,
            next_page: 2,
            response: { "numFound" => 20 }
          )
  end

  context "with no params" do
    let(:params) { { } }
    let(:resource_type) { :audio }
    let(:expected_query) { { "f": { "resource_type_sim" => ["Audio"], "curated_sim" => "1" } } }
    let(:document_ids) { [42, 58] }
    let(:documents) { document_ids.map { |id| double("SolrDocument", id: id) } }

    before do
      allow(catalog_query).to receive(:search_results).with(expected_query, logic) { [response, documents] }
      allow(file_query).to receive(:find).with(document_ids) { files }
    end

    it "returns curated files" do
      expect(search.result.files).to eq files
    end

    context "with resource_type selected and no other filters" do
      let(:params) { { types: ["audios"] } }
      let(:resource_type) { :audio }
      let(:expected_query) { { f: { "resource_type_sim" => %w[Audio] } } }

      it "returns found files" do
        expect(search.result.files).to eq files
      end
    end
  end

  describe "filtering" do
    let(:document_ids) { [42, 58] }
    let(:documents) { document_ids.map { |id| double("SolrDocument", id: id) } }
    let(:resource_type) { :audio }

    before do
      allow(catalog_query).to receive(:search_results).with(expected_query, logic) { [response, documents] }
      allow(file_query).to receive(:find).with(document_ids) { files }
    end

    context "with a search term" do
      let(:params) { { q: "TERM" } }
      let(:expected_query) { { q: "TERM", f: { "resource_type_sim" => %w[Audio] } } }

      it "returns found files" do
        expect(search.result.files).to eq files
      end
    end

    context "with a selected work" do
      let(:params) { { work: "WORK" } }
      let(:expected_query) { { f: { "work_name_sim" => "WORK", "resource_type_sim" => ["Audio"] } } }

      it "returns found files" do
        expect(search.result.files).to eq files
      end
    end

    describe "by venue" do
      before do
        described_class::PRIMARY_VENUES.each do |name|
          ProductionCredits::Venue.create(name: name)
        end
      end

      context "with one venue selected" do
        let(:params) { { venues: %w[VENUE] } }
        let(:expected_query) { { f: { "venue_names_sim" => %w[VENUE], "resource_type_sim" => ["Audio"] } } }

        it "returns found files" do
          expect(search.result.files).to eq files
        end
      end

      context "with several venues selected" do
        let(:params) { { venues: %w[VENUE1 VENUE2] } }
        let(:expected_query) { { f: { "venue_names_sim" => %w[VENUE1 VENUE2], "resource_type_sim" => ["Audio"] } } }

        it "returns found files" do
          expect(search.result.files).to eq files
        end
      end

      context "with other venue selected" do
        let(:params) { { venues: [described_class::OTHER_VENUE] } }
        let(:expected_query) { { f: { "!venue_names_sim" => described_class::PRIMARY_VENUES, "resource_type_sim" => ["Audio"] } } }

        it "returns found files" do
          expect(search.result.files).to eq files
        end
      end

      context "with the other venue and some primary venues selected" do
        let(:params) { { venues: described_class::PRIMARY_VENUES.take(2) + [described_class::OTHER_VENUE] } }
        let(:expected_query) { { f: { "!venue_names_sim" => described_class::PRIMARY_VENUES.drop(2), "resource_type_sim" => ["Audio"] } } }

        it "returns found files" do
          expect(search.result.files).to eq files
        end
      end
    end

    describe "by year range" do
      context "with a limited range" do
        let(:params) { { years: "1968;1991" } }
        let(:expected_query) { { f: { "year_created_isi" => 1968..1991, "resource_type_sim" => ["Audio"] } } }

        it "returns found files" do
          expect(search.result.files).to eq files
        end
      end

      context "with the full date range" do
        let(:params) { { years: "#{default_range.begin};#{default_range.end}" } }
        let(:expected_query) { { f: { "resource_type_sim" => %w[Audio] } } }
        let(:default_range) { described_class.all_years }

        it "returns found files" do
          expect(search.result.files).to eq files
        end
      end
    end
  end

  describe "years parameter parsing" do
    let(:range) { search.year_range }
    let(:default_range) { described_class.all_years }

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

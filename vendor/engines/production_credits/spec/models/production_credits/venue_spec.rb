require 'spec_helper'

module ProductionCredits
  RSpec.describe Venue, :type => :model do
    let!(:canonical_venue) { Venue.create!(name: "Canonical") }
    let!(:alias_venue) { Venue.create!(name: "Alias", canonical_venue: canonical_venue) }

    describe "alias validation" do
      context "when adding an alias to a canonical venue" do
        let(:venue) { canonical_venue }
        let!(:new_alias) { Venue.create!(name: "New Alias") }

        before do
          new_alias.canonical_venue = venue
        end

        specify "the alias is valid" do
          expect(new_alias).to be_valid
        end

        specify "the canonical venue is valid" do
          expect(venue).to be_valid
        end
      end

      context "when adding an alias to an alias" do
        let(:venue) { alias_venue }
        let(:new_alias) { Venue.create!(name: "New Alias") }

        before do
          new_alias.canonical_venue = venue
        end

        it "is not valid" do
          expect(new_alias).not_to be_valid
        end
      end

      context "when adding a venue with aliases as an alias" do
        let(:venue) { canonical_venue }
        let(:new_canonical_venue) { Venue.create!(name: "New Canonical") }

        before do
          venue.canonical_venue = new_canonical_venue
        end

        it "is not valid" do
          expect(venue).not_to be_valid
        end
      end

      context "adding a venue as an alias of itself" do
        let(:venue) { Venue.create!(name: "Self Alias") }

        before do
          venue.canonical_venue = venue
        end

        it "is not valid" do
            expect(venue).not_to be_valid
        end
      end
    end

    describe "deleting a canonical venue" do
      before do
        canonical_venue.destroy!
      end

      it "makes any aliases into canonical venues" do
        expect(alias_venue.reload).to be_canonical
      end
    end

    describe "full name" do
      context "with a canonical venue" do
        let(:venue) { canonical_venue }

        it "uses its name as its full name" do
          expect(venue.full_name).to eq "Canonical"
        end
      end

      context "with an alias" do
        let(:venue) { alias_venue }

        it "constructs a full name from its own name and its canonical name" do
          expect(venue.full_name).to eq "Alias (Canonical)"
        end
      end
    end

    describe "all names" do
      context "with a canonical venue" do
        let(:venue) { canonical_venue }

        it "includes only its own name" do
          expect(venue.all_names).to eq [venue.name]
        end
      end

      context "with an alias" do
        let(:venue) { alias_venue }

        it "includes its own name and its canonical name" do
          expect(venue.all_names).to include(venue.name, canonical_venue.name)
        end
      end
    end
  end
end

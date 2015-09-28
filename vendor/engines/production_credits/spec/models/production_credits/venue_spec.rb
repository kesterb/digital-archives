require 'spec_helper'

module ProductionCredits
  RSpec.describe Venue, :type => :model do
    let(:canonical_venue) { Venue.create(name: "Canonical") }
    let(:alias_venue) { Venue.create(name: "Alias", canonical_venue: canonical_venue) }

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
  end
end

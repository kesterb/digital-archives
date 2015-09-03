require 'rails_helper'

describe GenericFile do
  subject(:file) do
    GenericFile.create do |f|
      f.apply_depositor_metadata "user"
    end
  end
  let(:production) { instance_double(ProductionCredits::Production, id: 42, production_name: "PRODUCTION", venue: production_venue) }
  let(:venue) { instance_double(ProductionCredits::Venue, id: 58, name: "VENUE") }
  let(:production_venue) { instance_double(ProductionCredits::Venue, name: "PRODUCTION VENUE") }
  let(:work) { instance_double(ProductionCredits::Work, id: 123, title: "WORK") }

  before do
    allow(ProductionCredits::Production).to receive(:find).with(production.id) { production }
    allow(ProductionCredits::Work).to receive(:find).with(work.id) { work }
    allow(ProductionCredits::Venue).to receive(:find).with(venue.id) { venue }
  end

  describe "associated production" do
    context "when there is a production_id" do
      before do
        file.production_id = production.id
        file.save!
      end

      it "sets the production name" do
        expect(file.production_name).to eq production.production_name
      end
    end

    context "when there isn't a production_id" do
      before do
        file.production_id = nil
        file.production_name = "PRODUCTION"
        file.save!
      end

      it "clears the production name" do
        expect(file.production_name).to be_blank
      end
    end

    context "when production_id is blank" do
      before do
        file.production_id = ""
        file.production_name = "PRODUCTION"
        file.save!
      end

      it "clears the production name" do
        expect(file.production_name).to be_blank
      end
    end
  end

  describe "associated work" do
    context "when there is a work_id" do
      before do
        file.work_id = work.id
        file.save!
      end

      it "sets the work name" do
        expect(file.work_name).to eq work.title
      end
    end

    context "when there isn't a work_id" do
      before do
        file.work_id = nil
        file.work_name = "WORK"
        file.save!
      end

      it "clears the work name" do
        expect(file.work_name).to be_blank
      end
    end

    context "when work_id is blank" do
      before do
        file.work_id = ""
        file.work_name = "WORK"
        file.save!
      end

      it "clears the work name" do
        expect(file.work_name).to be_blank
      end
    end
  end

  describe "associated venue" do
    context "when there is a venue_id" do
      before do
        file.venue_id = venue.id
        file.save!
      end

      it "sets the venue name" do
        expect(file.venue_name).to eq venue.name
      end
    end

    context "when there isn't a venue_id" do
      before do
        file.venue_id = nil
        file.venue_name = "VENUE"
      end

      context "when there is a production" do
        before do
          file.production_id = production.id
          file.save!
        end

        it "uses the production's venue's name" do
          expect(file.venue_name).to eq production_venue.name
        end
      end

      context "when there isn't a production" do
        before do
          file.production_id = nil
          file.save!
        end

        it "clears the venue name" do
          expect(file.venue_name).to be_blank
        end
      end
    end

    context "when venue_id is blank" do
      before do
        file.venue_id = ""
        file.venue_name = "VENUE"
        file.save!
      end

      it "clears the venue name" do
        expect(file.venue_name).to be_blank
      end
    end
  end

  describe "creation year" do
    context "when there is a creation date" do
      let(:date) { "1968-03-07" }
      before do
        file.date_created = [date]
        file.save!
      end

      it "sets the creation year" do
        expect(file.year_created).to eq 1968
      end
    end

    context "when there isn't a creation date" do
      before do
        file.date_created = nil
        file.year_created = 1492
        file.save!
      end

      it "clears the creation year" do
        expect(file.year_created).to be_blank
      end
    end

    context "when creation dates are empty" do
      before do
        file.date_created = []
        file.year_created = 1492
        file.save!
      end

      it "clears the creation year" do
        expect(file.year_created).to be_blank
      end
    end
  end
end

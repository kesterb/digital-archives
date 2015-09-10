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
    allow(ProductionCredits::Production).to receive(:find).with([production.id]) { [production] }
    allow(ProductionCredits::Production).to receive(:find).with([]) { [] }
    allow(ProductionCredits::Work).to receive(:find).with(work.id) { work }
    allow(ProductionCredits::Venue).to receive(:find).with([venue.id]) { [venue] }
    allow(ProductionCredits::Venue).to receive(:find).with([]) { [] }
  end

  describe "associated production" do
    context "when there are production_ids" do
      before do
        file.production_ids = [production.id]
        file.save!
      end

      it "sets the production names" do
        expect(file.production_names).to eq [production.production_name]
      end
    end

    context "when there aren't production_ids" do
      before do
        file.production_ids = []
        file.production_names = ["PRODUCTION"]
        file.save!
      end

      it "clears the production names" do
        expect(file.production_names).to be_empty
      end
    end

    context "when production_ids is nil" do
      before do
        file.production_ids = nil
        file.production_names = ["PRODUCTION"]
        file.save!
      end

      it "clears the production names" do
        expect(file.production_names).to be_empty
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

  describe "associated venues" do
    context "when there are venue_ids" do
      before do
        file.venue_ids = [venue.id]
        file.save!
      end

      it "sets the venue names" do
        expect(file.venue_names).to eq [venue.name]
      end
    end

    context "when there aren't venue_ids" do
      before do
        file.venue_ids = []
        file.venue_names = ["VENUE"]
      end

      context "when there are productions" do
        before do
          file.production_ids = [production.id]
          file.save!
        end

        it "uses the productions' venue's names" do
          expect(file.venue_names).to eq [production_venue.name]
        end
      end

      context "when there aren't productions" do
        before do
          file.production_ids = []
          file.save!
        end

        it "clears the venue name" do
          expect(file.venue_names).to be_empty
        end
      end
    end

    context "when venue_ids is nil" do
      before do
        file.venue_ids = nil
        file.venue_names = ["VENUE"]
        file.save!
      end

      it "clears the venue names" do
        expect(file.venue_names).to be_empty
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

require "rails_helper"

describe UpdatesProductionCredits do
  subject { described_class.new(file) }
  let(:file) { GenericFile.new }
  let(:production) do
    instance_double(ProductionCredits::Production,
                    id: 42,
                    production_name: "PRODUCTION",
                    work: production_work
    )
  end
  let(:venue) { instance_double(ProductionCredits::Venue, id: 58, name: "VENUE") }
  let(:work) { instance_double(ProductionCredits::Work, id: 123, title: "WORK") }
  let(:production_work) { instance_double(ProductionCredits::Work, id: 443, title: "PRODUCTION WORK") }

  before do
    allow(ProductionCredits::Production).to receive(:find).with([production.id]) { [production] }
    allow(ProductionCredits::Production).to receive(:find).with([]) { [] }
    allow(ProductionCredits::Work).to receive(:find).with([work.id]) { [work] }
    allow(ProductionCredits::Work).to receive(:find).with([]) { [] }
    allow(ProductionCredits::Venue).to receive(:find).with([venue.id]) { [venue] }
    allow(ProductionCredits::Venue).to receive(:find).with([]) { [] }
  end

  describe "associated production" do
    context "when there are production_ids" do
      before do
        file.production_ids = [production.id]
        subject.update
      end

      it "sets the production names" do
        expect(file.production_names).to eq [production.production_name]
      end
    end

    context "when there aren't production_ids" do
      before do
        file.production_ids = []
        file.production_names = ["PRODUCTION"]
        subject.update
      end

      it "clears the production names" do
        expect(file.production_names).to be_empty
      end
    end

    context "when production_ids is nil" do
      before do
        file.production_ids = nil
        file.production_names = ["PRODUCTION"]
        subject.update
      end

      it "clears the production names" do
        expect(file.production_names).to be_empty
      end
    end
  end

  describe "associated work" do
    context "when there are work_ids" do
      before do
        file.work_ids = [work.id]
        subject.update
      end

      it "sets the work names" do
        expect(file.work_names).to eq [work.title]
      end
    end

    context "when there aren't work_ids" do
      before do
        file.work_ids = []
        file.work_names = ["WORK"]
      end

      context "when there are productions" do
        before do
          file.production_ids = [production.id]
          subject.update
        end

        it "uses the productions' work's ids" do
          expect(file.work_ids).to eq [production_work.id.to_s]
        end

        it "uses the productions' work's titles" do
          expect(file.work_names).to eq [production_work.title]
        end
      end

      context "when there aren't productions" do
        before do
          file.production_ids = []
          subject.update
        end

        it "clears the work names" do
          expect(file.work_names).to be_empty
        end
      end
    end

    context "when work_ids is nil" do
      before do
        file.work_ids = nil
        file.work_names = ["WORK"]
        subject.update
      end

      it "clears the work names" do
        expect(file.work_names).to be_empty
      end
    end
  end

  describe "associated venues" do
    context "when there are venue_ids" do
      before do
        file.venue_ids = [venue.id]
        subject.update
      end

      it "sets the venue names" do
        expect(file.venue_names).to eq [venue.name]
      end
    end

    context "when there aren't venue_ids" do
      before do
        file.venue_ids = []
        file.venue_names = ["VENUE"]
        subject.update
      end

      it "clears the venue name" do
        expect(file.venue_names).to be_empty
      end
    end

    context "when venue_ids is nil" do
      before do
        file.venue_ids = nil
        file.venue_names = ["VENUE"]
        subject.update
      end

      it "clears the venue names" do
        expect(file.venue_names).to be_empty
      end
    end
  end
end

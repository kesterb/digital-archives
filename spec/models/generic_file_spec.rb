require 'rails_helper'

describe GenericFile do
  subject(:file) do
    GenericFile.create do |f|
      f.apply_depositor_metadata "user"
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

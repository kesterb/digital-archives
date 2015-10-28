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
      end

      it "leaves the creation year alone" do
        expect { file.save! }.not_to change { file.year_created }
      end
    end

    context "when creation dates are empty" do
      before do
        file.date_created = []
        file.year_created = 1492
      end

      it "leaves the creation year alone" do
        expect { file.save! }.not_to change { file.year_created }
      end
    end

    context "when creation year is a string" do
      # For some reason, Sufia is giving us a string instead of a year from
      # its update action.
      before do
        file.year_created = "1972"
        file.save!
      end

      it "converts the string to an integer" do
        expect(file.year_created).to eq 1972
      end
    end
  end

  describe "year only" do
    [
        # context                         date          year  result
      [ "neither creation date nor year", nil,          nil,  false ],
      [ "only a creation year",           nil,          1992, true  ],
      [ "both creation date and year",    "10/15/2015", 2015, false ]
    ].each do |description, date, year, expected|
      context "when file has #{description}" do
        before do
          file.date_created = Array(date)
          file.year_created = year
        end

        it "#{expected ? 'has' : 'does not have'} a year only" do
          expect(file.has_year_only?).to eq expected
        end
      end
    end
  end
end

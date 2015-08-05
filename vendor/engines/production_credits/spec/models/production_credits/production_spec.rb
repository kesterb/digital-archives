require 'spec_helper'

module ProductionCredits
  describe Production, :type => :model do
    it {should belong_to :work}
    it {should belong_to :venue}
  end
end

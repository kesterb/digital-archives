require 'spec_helper'

module ProductionCredits
  describe Production, :type => :model do
    it { should belong_to :work }
    it { should have_and_belong_to_many :venues }
  end
end

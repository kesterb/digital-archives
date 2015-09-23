require 'spec_helper'

module ProductionCredits
  RSpec.describe Venue, :type => :model do
    it { should have_and_belong_to_many :productions }
  end
end

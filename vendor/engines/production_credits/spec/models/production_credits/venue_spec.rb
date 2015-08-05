require 'spec_helper'

module ProductionCredits
  RSpec.describe Venue, :type => :model do
    it {should have_many :productions}
  end
end

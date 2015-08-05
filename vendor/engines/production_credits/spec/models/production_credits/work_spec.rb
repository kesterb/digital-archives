require 'spec_helper'

module ProductionCredits
  RSpec.describe Work, :type => :model do
    it {should have_many :productions}

  end
end

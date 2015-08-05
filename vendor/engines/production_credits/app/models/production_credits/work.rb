module ProductionCredits
  class Work < ActiveRecord::Base
    has_many :productions

    validates_presence_of :title

  end
end

module ProductionCredits
  class EventType < ActiveRecord::Base
    validates_presence_of :name
  end
end

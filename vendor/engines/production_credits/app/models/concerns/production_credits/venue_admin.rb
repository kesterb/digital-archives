module ProductionCredits
  module VenueAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          sort_by :name
        end
        object_label_method :full_name

        configure :canonical_venue do
          associated_collection_scope do
            Proc.new { |scope| scope.canonical }
          end
        end

        configure :aliases do
          hide
        end
      end
    end
  end
end

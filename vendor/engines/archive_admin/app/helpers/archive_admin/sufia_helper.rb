module ArchiveAdmin
  module SufiaHelper
    include ::BlacklightHelper
    include Sufia::BlacklightOverride
    include Sufia::SufiaHelperBehavior
  end
end

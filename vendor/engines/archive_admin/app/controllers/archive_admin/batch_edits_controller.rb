module ArchiveAdmin
  class BatchEditsController < ApplicationController
    include Hydra::BatchEditBehavior
    include GenericFileHelper
    include Sufia::BatchEditsControllerBehavior

    def terms
      BatchEditForm.terms
    end
  end
end

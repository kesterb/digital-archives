class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior

  self.presenter_class = GenericFilePresenter
  self.edit_form_class = FileEditForm

  def update
    if params[:visibility] == "discoverable"
      @generic_file.set_discover_groups(%w[public], [])
      params[:visibility] = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end

    super
  end
end

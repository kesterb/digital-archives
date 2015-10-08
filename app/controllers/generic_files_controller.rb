class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior

  self.presenter_class = GenericFilePresenter
  self.edit_form_class = FileEditForm

  def update
    file_params = params[:generic_file] || {}
    if ActiveRecord::Type::Boolean.new.type_cast_from_user(file_params.delete(:has_year_only))
      file_params[:date_created] = []
    else
      file_params[:year_created] = nil
    end

    if params[:visibility] == "discoverable"
      @generic_file.set_discover_groups(%w[public], [])
      params[:visibility] = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end

    super
  end
end

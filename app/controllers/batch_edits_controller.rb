class BatchEditsController < ApplicationController
  include Hydra::BatchEditBehavior
  include GenericFileHelper
  include Sufia::BatchEditsControllerBehavior

  def self.edit_form_class
    BatchEditForm
  end

  def terms
    self.class.edit_form_class.terms
  end

  # This is an override of sufia/app/controllers/concerns/sufia/batch_edits_controller_behavior.rb.
  # See below for changes.
  def edit
    @generic_file = ::GenericFile.new
    @generic_file.depositor = current_user.user_key
    @terms = terms - [:title, :format, :resource_type]

    h = {}
    @names = []
    permissions = []

    # For each of the files in the batch, set the attributes to be the concatination of all the attributes
    batch.each do |doc_id|
      gf = ::GenericFile.load_instance_from_solr(doc_id)
      terms.each do |key|
        # OVERRIDE: Handle singular proprties by choosing the first non-nil value.
        value = gf.send(key)
        case value
        when Array
          h[key] ||= []
          h[key] = (h[key] + value).uniq
        else
          h[key] ||= value
        end
        # END OVERRIDE
      end
      @names << gf.to_s
      permissions = (permissions + gf.permissions).uniq
    end

    initialize_fields(h, @generic_file)

    @generic_file.permissions_attributes = [{ type: "group", name: "public", access: "read" }]
  end

  def generic_file_params
    file_params = params[:generic_file] || ActionController::Parameters.new
    self.class.edit_form_class.model_attributes(file_params)
  end
end

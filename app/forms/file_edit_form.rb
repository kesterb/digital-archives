class FileEditForm < GenericFilePresenter
  include HydraEditor::Form
  include HydraEditor::Form::Permissions

  self.required_fields = [:title, :rights]

  def self.build_permitted_params
    permitted = super
    permitted.delete(resource_type: [])
    permitted << :resource_type
    permitted
  end
end

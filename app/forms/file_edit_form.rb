class FileEditForm < GenericFilePresenter
  include HydraEditor::Form
  include HydraEditor::Form::Permissions

  self.required_fields = [:title, :rights]
end

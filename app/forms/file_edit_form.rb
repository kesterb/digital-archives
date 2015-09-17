class FileEditForm < GenericFilePresenter
  include HydraEditor::Form
  include HydraEditor::Form::Permissions

  self.required_fields = %i[title rights date_created]
end

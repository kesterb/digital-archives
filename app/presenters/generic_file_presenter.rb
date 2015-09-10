class GenericFilePresenter < Sufia::GenericFilePresenter
  self.terms = [
    :resource_type,
    :title,
    :creator,
    :contributor,
    :description,
    :tag,
    :rights,
    :publisher,
    :date_created,
    :language,
    :identifier,
    :based_near,
    :related_url,
    :production_names,
    :venue_names,
    :work_name,
    :highlighted
  ]
end

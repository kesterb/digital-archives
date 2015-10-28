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
    :year_created,
    :language,
    :identifier,
    :based_near,
    :related_url,
    :production_ids,
    :venue_ids,
    :event_type_id,
    :curated
  ]

  # Names are not displayed directly so don't include them in `terms'.
  delegate :production_names, :venue_names, :venue_full_names, :event_type_name, to: :model

  delegate :public?, :discoverable?, :restricted?, :private?, :has_year_only?, to: :model
end

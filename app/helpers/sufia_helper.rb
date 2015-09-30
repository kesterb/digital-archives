module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def render_visibility_label(document)
    case
    when document.public?
      content_tag :span, t("sufia.visibility.open"), class: "label label-success", title: t("sufia.visibility.open_title_attr")
    when document.discoverable?
      content_tag :span, t("digital_archives.visibility.discoverable"), class: "label label-warning", title: t("digital_archives.visibility.discoverable_title_attr")
    when document.registered?
      content_tag :span, t("sufia.institution_name"), class: "label label-info", title: t("sufia.institution_name")
    else
      content_tag :span, t("sufia.visibility.private"), class: "label label-danger", title: t("sufia.visibility.private_title_attr")
    end
  end
end

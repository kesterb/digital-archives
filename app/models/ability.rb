class Ability
  include Hydra::Ability
  include Sufia::Ability

  # Define any customized permissions here.
  def custom_permissions
    override_download_permissions
  end

  private

  # Maybe there's a way to not duplicate the code from hydra-access-controls
  # in override_download_permissions.

  def override_download_permissions
    can :download, ActiveFedora::File do |file|
      parent_uri = file.uri.to_s.sub(/\/[^\/]*$/, "")
      parent_id = ActiveFedora::Base.uri_to_id(parent_uri)
      if file.uri.end_with?("thumbnail")
        can? :discover, parent_id
      else
        can? :read, parent_id
      end
    end
  end
end

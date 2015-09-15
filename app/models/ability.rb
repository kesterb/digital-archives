class Ability
  include Hydra::Ability
  include Sufia::Ability

  # Define any customized permissions here.
  def custom_permissions
    discover_permissions
    override_download_permissions
  end

  private

  # TODO: discover_permissions and friends should really be moved into
  # hydra_access_controls.  We should fork that gem and make the change
  # there instead, then submit it as a PR.
  #
  # override_download_permissions should stay here, but maybe there's a
  # way to not duplicate the code from hydra_access_controls.

  def discover_permissions
    can :discover, String do |id|
      test_discover(id)
    end

    can :discover, ActiveFedora::Base do |obj|
      test_discover(obj.id)
    end

    can :discover, SolrDocument do |obj|
      cache.put(obj.id, obj)
      test_discover(obj.id)
    end
  end

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

  def test_discover(id)
    Rails.logger.debug("[CANCAN] Checking discover permissions for user: #{current_user.user_key} with groups: #{user_groups.inspect}")
    group_intersection = user_groups & discover_groups(id)
    result = !group_intersection.empty? || discover_users(id).include?(current_user.user_key)
    result
  end

  # read implies discover, so discover_groups is the union of read and discover groups
  def discover_groups(id)
    doc = permissions_doc(id)
    return [] if doc.nil?
    dg = read_groups(id) | (doc[self.class.discover_group_field] || [])
    Rails.logger.debug("[CANCAN] discover_groups: #{dg.inspect}")
    dg
  end

  # read implies discover, so discover_users is the union of read and discover users
  def discover_users(id)
    doc = permissions_doc(id)
    return [] if doc.nil?
    dp = read_users(id) | (doc[self.class.discover_user_field] || [])
    Rails.logger.debug("[CANCAN] discover_users: #{dp.inspect}")
    dp
  end

  def self.discover_group_field
    Hydra.config.permissions.discover.group
  end

  def self.discover_user_field
    Hydra.config.permissions.discover.individual
  end
end

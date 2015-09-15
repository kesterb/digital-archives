class CmsPagesController < PagesController
  layout "client"
  skip_before_action :authenticate_user!
end

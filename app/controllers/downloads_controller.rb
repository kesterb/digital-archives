class DownloadsController < ApplicationController
  skip_before_action :authenticate_user!

  include Sufia::DownloadsControllerBehavior
end

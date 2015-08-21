module ProductionCredits


  class WorksController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_filter :authenticate_user!

    def index
      headers['Access-Control-Allow-Origin'] = '*'
      works = Work.all
      render json: { 'works' => works }, layout: false
    end
  end
end

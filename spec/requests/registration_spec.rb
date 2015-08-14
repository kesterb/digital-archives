require "rails_helper"

describe "User Registration", :type => :request do
  it "does not allow registration and redirects" do
    get "/users/sign_up"
    expect(response).to redirect_to root_path
  end
end

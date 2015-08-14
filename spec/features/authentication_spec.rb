require 'rails_helper'

describe "authentication", type: :feature do
  describe "generic page access" do
    context 'when logged in' do
      before do
        login_as FactoryGirl.create(:jill) # Using factory girl as an example
        visit about_path
      end

      it "shows the requested page" do
        expect(page).to have_content "About"
      end
    end

    context 'when not logged in' do
      before do
        visit about_path
      end

      it "prompts the user to sign in" do
        expect(page).to have_content "You need to sign in before continuing"
      end
    end
  end

  describe "new user registration" do
    before do
      visit new_user_session_path
    end

    it "does not allow new users to sign up" do
      expect(page).not_to have_content "Sign up"
    end
  end
end

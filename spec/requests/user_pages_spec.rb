require 'spec_helper'

describe "User pages" do

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { expect(page).to have_selector('h1', text: user.name) }
    it { expect(page).to have_selector('title', text: user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { expect(page).to have_selector('h1', text: 'Sign up') }
    it { expect(page).to have_selector('title', text: full_title('Sign up')) }

  end

end

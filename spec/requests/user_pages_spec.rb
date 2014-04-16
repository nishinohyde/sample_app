# -*- coding: utf-8 -*-
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

    let(:submit) { "Create my account" }

    it { expect(page).to have_selector('h1', text: 'Sign up') }
    it { expect(page).to have_selector('title', text: full_title('Sign up')) }

    describe "正しくない情報を与えた時" do
      it "userが作られない" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "submission後" do
        before { click_button submit }
        it { expect(page).to have_selector('title',text: "Sign up") }
        it { expect(page).to have_content('error') }
      end
    end

    describe "正しい情報を与えた時" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "userが作られる" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "submission後" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com')}

        it { expect(page).to have_selector('title',text: user.name) }
        it { expect(page).to have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end

  end

end

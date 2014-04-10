# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Authentication" do

  describe "signin" do
    before { visit signin_path }

    describe "間違った入力の時" do
      before do
        click_button "Sign in"
      end

      it { expect(page).to have_selector('title', text: "Sign in") }
      it { expect(page).to have_selector('div.alert.alert-error', text: "Invalid")}
      describe "他のページに移動後" do
        before { click_link "Home" }
        it { expect(page).not_to have_selector('div.alert.alert-error') }
      end
    end

    describe "正しい入力の時" do
      let(:user){ FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { expect(page).to have_selector('title', text: user.name) }
      it { expect(page).to have_link('Profile', href: user_path(user)) }
      it { expect(page).to have_link('Sign out', href: signout_path) }
      it { expect(page).not_to have_link('Sign in', href: signin_path) }
    end

  end
end

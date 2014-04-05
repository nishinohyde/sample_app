# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Expample User", email: "user@example.co.jp",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  specify { expect(@user).to respond_to(:name) }
  specify { expect(@user).to respond_to(:email) }
  specify { expect(@user).to respond_to(:password_digest) }
  specify { expect(@user).to respond_to(:password)}
  specify { expect(@user).to respond_to(:password_confirmation)}
  specify { expect(@user).to respond_to(:authenticate)}

  specify { expect(@user).to be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    specify { expect(@user).not_to be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a"*51 }
    specify { expect(@user).not_to be_valid }
  end

  describe "emailが空の時" do
    before { @user.email = " " }
    specify { expect(@user).not_to be_valid }
  end

  describe "emailの形式が正しくない時" do
    specify "invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "emailの形式が正しい時" do
    specify "valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "同じemailアドレスが登録済みの時" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    specify "invalidになる" do
      expect(@user).not_to be_valid
    end
  end

  describe "passwordが空の時" do
    before { @user.password = @user.password_confirmation = " " }
    it { expect(@user).not_to be_valid }
  end

  describe "passwordがpassword_confirmationと一致しない時" do
    before { @user.password_confirmation = "mismatch" }
    it { expect(@user).not_to be_valid }
  end

  describe "password_confirmationがnilの時" do
    before { @user.password_confirmation = nil }
    it { expect(@user).not_to be_valid }
  end

  describe "authenticateメソッドの戻り値" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "正しいpasswordを指定した時" do
      specify { expect(@user).to eq found_user.authenticate(@user.password) }
    end

    describe "間違ったpasswordを指定した時" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      specify { expect(@user).not_to eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end

  end

end

require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:auth_token) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }

  # Test that the auth_token is unique
  it { should validate_uniqueness_of(:auth_token) }

  describe "#generate_auth_token!" do
  	it "generates a unique token" do
  		Devise.stub(:friendly_token).and_return("auniquetoken1234")
  		@user.generate_auth_token!
  		expect(@user.auth_token).to eql "auniquetoken1234"
  	end

  	it "generates another token when one has already been taken" do
  		existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken1234")
  		@user.generate_auth_token!
  		expect(@user.auth_token).not_to eql existing_user.auth_token
  	end
  end

end
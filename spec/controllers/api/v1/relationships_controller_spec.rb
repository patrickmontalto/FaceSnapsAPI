require 'spec_helper'

describe Api::V1::RelationshipsController do

	describe "GET #current_user_follows" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.auth_token
		end

		context "when signed in" do
			before(:each) do
				other = FactoryGirl.create :user
				@user.save
				other.save
				sign_in @user
				@user.follow(other)
			end

			it "returns the list of users who the current user follows" do
				get :current_user_follows
				expect(json_response[:users].count).to eql 1
			end

		end
	end

	describe "GET #follows" do
		before(:each) do
		end

		context "when signed in" do
		end
	end

end
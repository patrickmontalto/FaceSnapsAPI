require 'spec_helper'

describe Api::V1::RelationshipsController do

  # Returning list of who the current user follows
	describe "GET #current_user_follows" do
		before(:each) do
			@user = FactoryGirl.create :user
      other = FactoryGirl.create :user
      @user.save
      other.save
      @user.follow(other)
		end

		context "when signed in" do
			before(:each) do
        api_authorization_header @user.auth_token
        get :current_user_follows
			end

			it "returns the list of users who the current user follows" do
				expect(json_response[:users].count).to eql 1
			end

		end

    context "when not signed in" do
      it "responds with not authenticated" do
        get :current_user_follows 
        expect(json_response[:errors]).to eql "Not authenticated"
      end
    end
	end

  # Returning list of who a given user follows
	describe "GET #follows" do
		before(:each) do
      @user = FactoryGirl.create :user
      @other = FactoryGirl.create :user
      @other.save
      @user.save
      @other.follow(@user)
		end

		context "when signed in" do
      before(:each) { api_authorization_header @user.auth_token }

      it "returns the list of users who a given user id follows" do
        get :follows, { id: @other.id }
        expect(json_response[:users].count).to eql 1
      end
		end

    context "when not signed in" do
      it "responds with not authenticated" do
        get :follows, { id: @other.id }
        expect(json_response[:errors]).to eql "Not authenticated"
      end
    end
	end

  # Returns who follows the current user
  describe "GET #current_user_followed_by" do
    before(:each) do
      @user = FactoryGirl.create :user
      @other = FactoryGirl.create :user
      @other.save
      @user.save
      @other.follow(@user)
    end

    context "when signed in" do
      before { api_authorization_header @user.auth_token }

      it "returns the list of users who follow the current user" do
        get :current_user_followed_by
        expect(json_response[:users].count).to eql 1
      end
    end

  end


  describe "POST #manage" do
    context "when signed in" do
      before(:each) do
        @user = FactoryGirl.create :user
        @other = FactoryGirl.create :user
        api_authorization_header @user.auth_token
      end

      context "with action: follow" do
        before { get :manage, { user_action: 'follow', id: @other.id } }
        it "follows the user and returns the status" do
          expect(json_response[:data][:outgoing_status]).to eql "follows"
        end
      end

      context "with action: unfollow" do
        before do 
          FactoryGirl.create :relationship, { follower: @user, followed: @other }
          get :manage, { user_action: 'unfollow', id: @other.id }
        end

        it "unfollows the user and returns the status" do
          expect(json_response[:data][:outgoing_status]).to eql "none"
        end

      end

      context "with action: approve" do
        before do
          @user.private = true
          FactoryGirl.create :relationship, { follower: @other, followed: @user }
          get :manage, { user_action: 'approve', id: @other.id }
        end

        it "approves the request and returns the incoming status" do
          expect(json_response[:data][:incoming_status]).to eql "followed_by"
        end

      end

      context "with action: ignore" do
        before do
          @user.private = true
          FactoryGirl.create :relationship, { follower: @other, followed: @user }
          get :manage, { user_action: 'ignore', id: @other.id }
        end

        it "ignores the request and returns the incoming status" do
          expect(json_response[:data][:incoming_status]).to eql "none"
        end
      end

    end
  end

  describe "GET #requested_by" do
    context "when signed in" do
      before do
        @user = FactoryGirl.create :user, { private: true }
        other = FactoryGirl.create :user
        another = FactoryGirl.create :user
        FactoryGirl.create :relationship, { follower: other, followed: @user }
        FactoryGirl.create :relationship, { follower: another, followed: @user }
        api_authorization_header @user.auth_token
      end

      it "returns a list of users who have requested the current user" do
        get :requested_by
        expect(json_response[:users].count).to eql 2
      end
    end
  end

  describe "GET #status" do
    context "when signed in" do
      before do 
        @user = FactoryGirl.create :user, { private: true }
        @other = FactoryGirl.create :user
        FactoryGirl.create :relationship, { follower: @other, followed: @user }
        FactoryGirl.create :relationship, { follower: @user, followed: @other }
        api_authorization_header @user.auth_token
      end

      it "returns the appropriate status for a given relationship to a user" do
        get :status, { id: @other.id }
        expect(json_response[:data][:outgoing_status]).to eql "follows"
        expect(json_response[:data][:incoming_status]).to eql "requested_by"
      end
    end
  end

end
require 'spec_helper'

describe Api::V1::FeedController do
  describe "GET #show" do

    context "when signed in" do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        2.times do 
          other_user = FactoryGirl.create :user
          2.times { FactoryGirl.create :post, { user: other_user } }
          FactoryGirl.create :relationship, { follower: @user, followed: other_user }
        end
        FactoryGirl.create :post, user: @user
      end
      it "renders the feed of posts for a user in reverse order" do
        get :show
        expect(json_response[:posts].count).to eql 5
        expect(json_response[:posts].first[:user_id]).to eql @user.id
      end
    end

  end
end
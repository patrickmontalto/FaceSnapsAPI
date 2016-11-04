require 'spec_helper'

describe Api::V1::FeedController do
  describe "GET #show" do
    before(:each) do
      # @user will follow two other users
      # @user will create a post
      # two other users will have 2 posts each
      # For a total of 5 posts in the users feed
      @user = FactoryGirl.create :user
      FactoryGirl.create :post, user: @user
    end

    it "renders the feed of posts for a user" do
    end

  end

end

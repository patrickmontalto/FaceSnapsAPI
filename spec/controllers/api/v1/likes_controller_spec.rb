require 'spec_helper'

describe Api::V1::LikesController do
  before do
    @user = FactoryGirl.create :user
    @post = FactoryGirl.create :post
  end

  describe "GET #liked_posts" do
    context "when signed in" do
      before do
        api_authorization_header @user.auth_token
        3.times { FactoryGirl.create :like, { user: @user }}
      end
      it "returns a list of the recent posts liked by the current user" do
        get :liked_posts, { id: @user.id }
        expect(json_response[:posts].count).to eql 3
      end
    end
  end

  describe "GET #liking_users" do
    context "when signed in" do
      before do
        api_authorization_header @user.auth_token
        3.times { FactoryGirl.create :like, { post: @post } }
      end

      it "returns a list of users who have liked the post" do
        get :liking_users, { id: @post.id }
        expect(json_response[:users].count).to eql 3
      end
    end
  end

  describe "POST #create" do
    context "when signed in" do
      before do
        api_authorization_header @user.auth_token
      end

      it "sets a like on the post as the current user" do
        post :create, { id: @post.id }
        expect(@post.likes.count).to eql 1
        expect(@user.liked_posts).to include @post
        expect(json_response[:meta][:code]).to eql 200
      end

      context "and already liking a post" do
        before do
          FactoryGirl.create :like, { user: @user, post: @post }
        end
        it "returns an error" do
          post :create, { id: @post.id }
          expect(@post.likes.count).to eql 1
          expect(json_response[:errors]).to eql "Unable to like post: nothing to like."
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when signed in" do
     before do
        api_authorization_header @user.auth_token
        FactoryGirl.create :like, { post: @post, user: @user }
     end

      it "unlikes a post as the current user" do
        delete :destroy, { id: @post.id }
        expect(@post.likes.count).to eql 0
        expect(@user.liked_posts).to_not include @post
        expect(json_response[:meta][:code]).to eql 200
      end
    end
  end
end
